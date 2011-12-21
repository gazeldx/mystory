module CategoriesHelper
  def query_categories
    @_categories = Category.where(["user_id = ?", session[:id]]).order('created_at') 
  end
end