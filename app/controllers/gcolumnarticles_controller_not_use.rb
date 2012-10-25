#Never been used
class ColumnblogsController < ApplicationController
  before_filter :group_admin
  skip_before_filter :url_authorize
  layout 'help'

  def index
    following = Follow.where(["follower_id = ?", @user.id])
    
    user_ids = following.collect{|f| f.followable_id}
    Blog.where(:is_draft => false).includes(:category, :user)

    @articles = Blog.where(:is_draft => false).includes(:category, :user).page(params[:page]).order("created_at desc")
  end

end
