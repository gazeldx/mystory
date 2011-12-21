class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
  end

  def show
    query_categories
    @blog = Blog.find(params[:id])
    @blog_pre = Blog.where(["user_id = ? AND category_id = ? AND created_at > ?", @user.id, @blog.category_id, @blog.created_at]).order('created_at').first
    @blog_next = Blog.where(["user_id = ? AND category_id = ? AND created_at < ?", @user.id, @blog.category_id, @blog.created_at]).order('created_at DESC').first
    @blogs_recommend = Blog.where(["user_id = ? AND recommend = true", @user.id]).limit(5)
    @blogs_new = Blog.where(["user_id = ?", @user.id]).order('created_at DESC').limit(10)
  end
end