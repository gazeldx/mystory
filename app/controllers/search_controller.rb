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

  def all
    if @user.nil?
      blogs = Blog
      notes = Note
    else
      blogs = @user.blogs
      notes = @user.notes
    end
    blogs = blogs.where("title like ?", "%#{params[:title]}%").includes(:user).order('comments_count DESC')
    notes = notes.where("title like ?", "%#{params[:title]}%").includes(:user).order('comments_count DESC')
    @all = blogs | notes
  end
end