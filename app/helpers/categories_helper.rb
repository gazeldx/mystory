module CategoriesHelper
  def query_categories
    @_categories = Category.where(["user_id = ?", session[:id]]).order('created_at') 
  end

  def query_notecates
    @_notecates = Notecate.where(["user_id = ?", session[:id]]).order('created_at')
#    default_category = Notecate.new
#    default_category.name = t'default_notecate_name'
#    @_notecates.unshift(default_category)
  end

  def user_categories
    @categories_ = Category.where(["user_id = ?", @user.id]).order('created_at')
  end
end