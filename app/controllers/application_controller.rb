class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :query_user_by_domain
  
  def login_now
    session[:user_id]=@user.id
    session[:user]=@user
    #redirect_to "http://"+@user.domain+".localhost:3000/admin"
    redirect_to "http://"+@user.domain+":3000/like"
  end

  private
  def query_user_by_domain
    if request.domain=="mystory.cc"
      @user = User.where(["username = ?", request.subdomain[0]]).first
    elsif request.domain=="127.0.0.1"
      
    else
      @user = User.where(["domain = ?", request.domain]).first
    end
    #redirect_to '/gazeldx' unless @user.nil?
  end
end
