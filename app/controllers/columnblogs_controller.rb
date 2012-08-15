class ColumnblogsController < ApplicationController
  before_filter :super_admin
  skip_before_filter :url_authorize
  layout 'help'

  def index
    @blogs = Blog.where(:is_draft => false).includes(:category, :user).page(params[:page]).order("created_at desc")
  end

end
