class WeiboController < ApplicationController
  Weibo::Config.api_key = WEIBO_API_KEY
  Weibo::Config.api_secret = WEIBO_API_SECRET
  
  #  layout 'help'

  def connect
    oauth = Weibo::OAuth.new(WEIBO_API_KEY, WEIBO_API_SECRET)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect_to "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/weibo_callback"
  end

  def callback
    oauth = Weibo::OAuth.new(WEIBO_API_KEY, WEIBO_API_SECRET)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    #    @timeline = Weibo::Base.new(oauth).friends_timeline
    #     friends = Weibo::Base.new(oauth).friends
    #     user = Weibo::Base.new(oauth).user(1837900163)
    @weibo_user = Weibo::Base.new(oauth).verify_credentials
    #    @user_show = Weibo::Base.new(oauth).user_show
    #    puts @user_show.inspect
    puts @weibo_user.inspect
    if session[:id].nil?
      @user = User.find_by_weiboid(@weibo_user.id)
      if @user.nil?
        render 'login_or_new', layout: 'portal'
      else
        proc_session
        flash[:notice] = t'weibo_login_succ'
        redirect_to my_site + like_path
      end
    else
      user = User.find_by_weiboid(@weibo_user.id)
      if user.nil?
        me = User.find(session[:id])
        me.update_attribute('weiboid', @weibo_user.id)
      else
        flash[:error] = t'weibo_bound_by_others'
      end
      redirect_to my_site + weibo_account_path
    end
  end

  def create_account
    @user = User.new
    @user.weiboid = params[:weiboid]
    @user.name = t'default_real_name'
    @user.passwd = Digest::SHA1.hexdigest((10000000+Random.rand(89999999)).to_s)
    id = User.last.id + 1000
    @user.username = "u#{id}"
    @user.domain = "u#{id}"
    @user.email = "u#{id}@mystory.cc"
    unless @user.save
      num = Random.rand(9999)
      @user.username = "u#{id}-#{num}"
      @user.domain = "u#{id}-#{num}"
      @user.email = "u#{id}-#{num}@mystory.cc"
      @user.save
    end
    proc_session
    flash[:notice] = t'weibo_regiter_succ_memo'
    redirect_to my_site + edit_profile_path
  end

  def weibo_account
    @_user = User.find(session[:id])
    render layout: 'help'
  end

  def cancel_weibo_bind
    @_user = User.find(session[:id])
    @_user.update_attribute('weiboid', nil)
    redirect_to :back
  end

  def friends_timeline
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    @timeline = Weibo::Base.new(oauth).friends_timeline
  end
end