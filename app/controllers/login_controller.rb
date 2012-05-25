class LoginController < ApplicationController
  layout 'portal_others'

  def to_login
    if @m
      render mr, layout: 'm/portal'
    end
  end

  #login in home page
  def member_login
    if params[:loginname] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      @user = User.find_by_email(params[:loginname])
      judge_user("email")
    else
      @user = User.find_by_username(params[:loginname])
      if @user.nil?
        @user = User.find_by_domain(params[:loginname])
        judge_user("domain")
      elsif @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
        login_now
      else
        @user = User.find_by_domain(params[:loginname])
        if @user.nil?
          flash[:error] = t'login.username_exist_password_wrong'
          go_redirect
        elsif @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
          login_now
        else
          flash[:error] = t'login.user_exist_password_wrong'
          go_redirect
        end
      end
    end
  end
  
  #in user domain login directly
  def login
    if @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
      login_now
    else
      flash[:error] = t'login.password_wrong'
      redirect_to "/login"
    end
  end

  private

  def login_now
    session[:id] = @user.id
    session[:name] = @user.name
    session[:domain] = @user.domain
    redirect_to m_or(my_site + like_path)
  end
  
  def judge_user(r)
    if @user.nil?
      if r == "email"
        flash[:error] = t'login.email_not_exist'
      else
        flash[:error] = t'login.user_not_exist'
      end
      go_redirect
    elsif @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
      login_now
    else
      if r == "email"
        flash[:error] = t'login.email_exist_password_wrong'
      else
        flash[:error] = t'login.domain_exist_password_wrong'
      end
      go_redirect
    end
  end

  def go_redirect
    if @m
      redirect_to login_path
    else
      redirect_to root_path
    end
  end
end