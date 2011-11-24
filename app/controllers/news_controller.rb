class NewsController < ApplicationController

  def index
    @news = News.where(["user_id = ?", @user.id]).page(params[:page]).order("created_at DESC")    
    @categories = Category.where(["user_id = ?", @user.id])
  end

  def show
    @news = News.find(params[:id])
    @categories = Category.where(["user_id = ?", @user.id])
  end
end