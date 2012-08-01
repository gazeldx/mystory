class SearchController < ApplicationController
  layout 'help'
  
  def index
    
  end

  def blogs
    if @user.nil?
      blogs = Blog.includes(:user)
    else
      blogs = @user.blogs
    end
    @blogs = blogs.where("title like ?", "%#{params[:title]}%").order('created_at DESC')
  end
end