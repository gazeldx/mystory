class LoginController < ApplicationController
  layout 'portal_others'

  def to_login
    if @m
      render mr, :layout => 'm/portal'
    else
      render :layout => 'portal_simple'
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

  #This is ajax login check.
  def bind_weibo_login
    if check_member == 0
      @user.update_attributes(:weiboid => params[:weiboid], :atoken => session[:atoken], :asecret => session[:expires_at])
      flash[:notice] = t'weibo_bind_succ'
      proc_session
      render json: @user.as_json
    else
      user = User.new
      user.memo = flash[:error]
      render json: user.as_json
    end
  end

  #This is ajax login check.
  def bind_qq_login
    if check_member==0
      @user.update_attributes(:openid => params[:openid], :token => session[:token])
      flash[:notice] = t'qq_bind_succ'
      proc_session
      render json: @user.as_json
    else
      user = User.new
      user.memo = flash[:error]
      render json: user.as_json
    end
  end
  
  #in user domain login directly, not used
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
    proc_session
    flash[:notice] = t('succ', :w => t('_login'))
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

  def judge_user_simple(r)
    if @user.nil?
      if r == "email"
        flash[:error] = t'login.email_not_exist'
      else
        flash[:error] = t'login.user_not_exist'
      end
    elsif @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
      0
    else
      if r == "email"
        flash[:error] = t'login.email_exist_password_wrong'
      else
        flash[:error] = t'login.domain_exist_password_wrong'
      end
    end
  end

  def go_redirect
#    if @m
      redirect_to login_path
#    else
#      redirect_to root_path
#    end
  end

  def check_member
    if params[:loginname] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      @user = User.find_by_email(params[:loginname])
      judge_user_simple("email")
    else
      @user = User.find_by_username(params[:loginname])
      if @user.nil?
        @user = User.find_by_domain(params[:loginname])
        judge_user_simple("domain")
      elsif @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
        0
      else
        @user = User.find_by_domain(params[:loginname])
        if @user.nil?
          flash[:error] = t'login.username_exist_password_wrong'
        elsif @user.passwd == Digest::SHA1.hexdigest(params[:passwd])
          0
        else
          flash[:error] = t'login.user_exist_password_wrong'
        end
      end
    end
  end
end