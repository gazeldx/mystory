class WeiboController < ApplicationController
  
  include AutoCreatedUserInfo
  def connect
    client = WeiboOAuth2::Client.new
    redirect_to client.authorize_url
  end

  def callback
    client = WeiboOAuth2::Client.new
    access_token = client.auth_code.get_token(params[:code].to_s)
    session[:atoken] = access_token.token
    session[:expires_at] = access_token.expires_at
    @weibo_user = client.users.show_by_uid(access_token.params["uid"].to_i)
    if session[:id].nil?
      @user = User.find_by_weiboid(@weibo_user.id.to_s)
      if @user.nil?
        render 'login_or_new', :layout => 'help'
      else
        @user.update_attributes(:atoken => session[:atoken], :asecret => session[:expires_at])
        proc_session
        flash[:notice] = t'weibo_login_succ'
        redirect_to my_site + like_path
      end
    else
      user = User.find_by_weiboid(@weibo_user.id.to_s)
      if user.nil?
        me = User.find(session[:id])
        me.update_attributes(:weiboid => @weibo_user.id.to_s, :atoken => session[:atoken], :asecret => session[:expires_at])
      else
        session[:atoken], session[:expires_at] = nil, nil
        flash[:error] = t'weibo_bound_by_others'
      end
      redirect_to my_site + weibo_account_path
    end
  end

  def create_account
    @user = User.new
    @user.weiboid = params[:weiboid]
    @user.atoken = session[:atoken]
    @user.asecret = session[:expires_at]
    same_user_info
    proc_session
    flash[:notice] = t'weibo_regiter_succ_memo'
    redirect_to my_site + edit_profile_path
  end

  def weibo_account
    @_user = User.find(session[:id])
    unless @_user.weiboid.nil?
      client = WeiboOAuth2::Client.new
      client.get_token_from_hash({:access_token => @_user.atoken, :expires_at => @_user.asecret})
      @weibo_user = client.users.show_by_uid(@_user.weiboid)
    end
    render :layout => 'help'
  end

  def cancel_weibo_bind
    @_user = User.find(session[:id])
    @_user.update_attributes(:weiboid => nil, :atoken => nil, :asecret => nil)
    session[:atoken], session[:expires_at] = nil, nil
    redirect_to :back
  end  
end