class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @blogs = Blog.where(["category_id = ?", params[:id]]).limit(20)
  end
end
