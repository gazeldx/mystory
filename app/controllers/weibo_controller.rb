class WeiboController < ApplicationController
  #  layout 'help'
  include AutoCreatedUserInfo
  def connect
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect_to "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/weibo_callback"
  end

  def callback
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    @weibo_user = Weibo::Base.new(oauth).verify_credentials
    puts @weibo_user.inspect
    puts session[:atoken]
    if session[:id].nil?
      @user = User.find_by_weiboid(@weibo_user.id)
      if @user.nil?
        render 'login_or_new', layout: 'portal'
      else
        @user.update_attributes(:atoken => session[:atoken], :asecret => session[:asecret])
        proc_session
        flash[:notice] = t'weibo_login_succ'
        redirect_to my_site + like_path
      end
    else
      user = User.find_by_weiboid(@weibo_user.id)
      if user.nil?
        me = User.find(session[:id])
        me.update_attributes(:weiboid => @weibo_user.id, :atoken => session[:atoken], :asecret => session[:asecret])
      else
        session[:atoken], session[:asecret] = nil, nil
        flash[:error] = t'weibo_bound_by_others'
      end
      redirect_to my_site + weibo_account_path
    end
  end

  def create_account
    @user = User.new
    @user.weiboid = params[:weiboid]
    @user.atoken = session[:atoken]
    @user.asecret = session[:asecret]
    same_user_info
    proc_session
    flash[:notice] = t'weibo_regiter_succ_memo'
    redirect_to my_site + edit_profile_path
  end

  def weibo_account
    @_user = User.find(session[:id])
    if @_user.weiboid.to_i > 0
      @weibo_user = verify_credentials
    end
    render layout: 'help'
  end

  def cancel_weibo_bind
    @_user = User.find(session[:id])
    @_user.update_attributes(:weiboid => nil, :atoken => nil, :asecret => nil)
    session[:atoken], session[:asecret] = nil, nil
    redirect_to :back
  end

  def friends_timeline
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    @timeline = Weibo::Base.new(oauth).friends_timeline
  end
end