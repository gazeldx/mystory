module Admin::NewsHelper
  def query_categories
    Category.where(["user_id = ?", session[:user_id]]).order('created_at')
  end
end
