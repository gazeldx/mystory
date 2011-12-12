class NewsController < ApplicationController

  def index    
    @news = News.where(["user_id = ?", @user.id]).page(params[:page]).order("created_at DESC")    
    q_categories
  end

  def show
    @news = News.find(params[:id])
    q_categories
  end

  private
  def q_categories
    @categories = Category.where(["user_id = ?", @user.id]).order('created_at')
  end
end