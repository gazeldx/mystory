class CategoriesController < ApplicationController

  def index
    @categories = Category.where(["user_id = ?", session[:user_id]])
  end
end
