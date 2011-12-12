#Administrators login
class Login2Controller < ApplicationController
  def to_login
  end

  def login
    if @user.passwd==params[:passwd]
      session[:user_id]=@user.id
      session[:user]=@user
      redirect_to admin_path
    else
      flash[:error]=t('login2.failed')
      redirect_to "/login2"
    end
  end
end