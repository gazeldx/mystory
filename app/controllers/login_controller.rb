#Member login
class LoginController < ApplicationController
  def to_login
    respond_to do |format|
      format.html
    end
  end

  def login
#    @user = User.where(["username = ?", params[:username]]).first
#    session["user_id"]=@user.id
#    redirect_to "/"+params[:username]
  end
end
