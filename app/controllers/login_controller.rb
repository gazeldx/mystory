#Client login
class LoginController < ApplicationController
  layout 'portal_others'
  #in user domain login directly
  def login
    if @user.passwd==params[:passwd]
      login_now
    else
      flash[:error]=t('login.password_wrong')
      redirect_to "/login"
    end
  end

  #login in home page
  def member_login
    if params[:loginname] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      @user = User.find_by_email(params[:loginname])
      judge_user
    else
      @user = User.find_by_username(params[:loginname])
      if @user.nil? || @user.passwd!=params[:passwd]
        @user = User.find_by_domain(params[:loginname])
        judge_user
      else
        login_now
      end
    end
  end

  private

  def login_now
    session[:id] = @user.id
    session[:name] = @user.name
    session[:domain] = @user.domain
    redirect_to "http://" + @user.domain + "." + DOMAIN_NAME + ":3000/like"
  end
  
  def judge_user
    if @user.nil?
      flash[:error]=t('login.user_not_exist')
      redirect_to root_path
    elsif @user.passwd==params[:passwd]
      login_now
    else
      flash[:error]=t('login.user_exist_password_wrong')
      redirect_to root_path
    end
  end
end