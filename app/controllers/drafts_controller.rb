class DraftsController < ApplicationController
  layout 'help'
  before_filter :url_authorize
  
  def index
    blogs = @user.blogs.where(:is_draft => true)
    notes = @user.notes.where(:is_draft => true)
    @all = (blogs | notes).sort_by{|x| x.updated_at}.reverse!
  end
end