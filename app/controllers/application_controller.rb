class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :query_user_by_domain

  def query_categories
    @categories = Category.where(["user_id = ?", @user.id]).order('created_at')
  end

  def sidebar_query
    @blogs_recommend = Blog.where(["user_id = ? AND recommend = true", @user.id]).limit(5)
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
