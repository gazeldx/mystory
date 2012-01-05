class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :query_user_by_domain

#  def query_categories
#    @categories = Category.where(["user_id = ?", @user.id]).order('created_at')
#  end  

  def my_site
    SITE_URL.sub(/\:\/\//, "://" + session[:domain] + ".")
  end
  
  private
  def query_user_by_domain
    if request.domain==DOMAIN_NAME
      @user = User.where(["domain = ?", request.subdomain]).first
    else
      @user = User.where(["domain = ?", request.domain]).first
    end
  end
end
