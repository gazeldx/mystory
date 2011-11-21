#Administrators login
class Login2Controller < ApplicationController
  def to_login
    respond_to do |format|
      format.html
    end
  end

  def login
    if @user.passwd==params[:passwd]
      session['user_id']=@user.id
      session['user']=@user
      respond_to do |format|
        format.html{redirect_to "/admin",notice:'Login success!'}
      end
    else
      respond_to do |format|
        format.html{redirect_to "/login2",notice:t('login2.failed')}
      end
    end
  end
end