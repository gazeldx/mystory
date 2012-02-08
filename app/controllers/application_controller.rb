class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :query_user_by_domain
  before_filter :url_authorize, :only => [:edit, :delete]

  def my_site
    SITE_URL.sub(/\:\/\//, "://" + session[:domain] + ".")
  end

  def site(user)
    SITE_URL.sub(/\:\/\//, "://" + user.domain + ".")
  end

  def authorize(item)
    unless item.user_id == session[:id]
      redirect_to site(@user)
    end
  end

  private
  def query_user_by_domain
    if request.domain==DOMAIN_NAME
      @user = User.where(["domain = ?", request.subdomain]).first
    else
      @user = User.where(["domain = ?", request.domain]).first
    end
  end

  def url_authorize
    unless @user.id == session[:id]
      redirect_to site(@user)
    end
  end
end
