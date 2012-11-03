require 'qq'
class QqController < ApplicationController

  include AutoCreatedUserInfo
  
  def connect
    redirect_to Qq.redo("get_user_info,add_share")
  end

  def callback
    qq = Qq.new
    qq.get_token(params[:code], request.env['HTTP_CONNECTION'])
    session[:token], session[:openid] = qq.token, qq.openid
    @qq_user = qq.get_user_info(qq.auth)
    if session[:id].nil?
      @user = User.find_by_openid(qq.openid)
      if @user.nil?
        render 'login_or_new', :layout => 'help'
      else
        @user.update_attributes(:token => session[:token])
        proc_session
        flash[:notice] = t'qq_login_succ'
        redirect_to my_site + like_path
      end
    else
      user = User.find_by_openid(qq.openid)
      if user.nil?
        me = User.find(session[:id])
        me.update_attributes(:openid => qq.openid, :token => qq.token)
      else
        session[:token], session[:openid] = nil, nil
        flash[:error] = t'qq_bound_by_others'
      end
      redirect_to my_site + qq_account_path
    end
  end

  def create_account
    @user = User.new
    @user.openid = params[:openid]
    @user.token = session[:token]
    same_user_info
    proc_session
    flash[:notice] = t'qq_regiter_succ_memo'
    redirect_to my_site + edit_profile_path
  end

  def qq_account
    @_user = User.find(session[:id])
    unless @_user.openid.nil?
      qq = Qq.new
      @qq_user = qq.get_user_info(qq.gen_auth(session[:token], session[:openid]))
    end
    render :layout => 'help'
  end

  def cancel_qq_bind
    @_user = User.find(session[:id])
    @_user.update_attributes(:openid => nil, :token => nil)
    session[:token], session[:openid] = nil, nil
    redirect_to :back
  end
  
end