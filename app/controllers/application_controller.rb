class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :query_user_by_domain
  
  private
  def query_user_by_domain
    if request.domain=="diancai.la"
      @user = User.where(["username = ?", request.subdomain[0]]).first
    else
      @user = User.where(["domain = ?", request.domain]).first
    end
  end
end
