class NewsController < ApplicationController

  def index
    puts @user.id
    @news = News.where(["user_id = ?", @user.id])
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @news = News.find(params[:id])
    @categories = Category.all

    respond_to do |format|
      format.html
    end
  end
end