module CategoriesHelper
  def query_categories
    @_categories = Category.where(["user_id = ?", session[:id]]).order('created_at') 
  end

  def user_categories
    @categories_ = Category.where(["user_id = ?", @user.id]).order('created_at')
  end
end