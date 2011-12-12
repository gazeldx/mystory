class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @categories = Category.where(["user_id = ?", @user.id]).order('created_at')
    @news=@category.news.page(params[:page]).order('created_at DESC')
  end
end
