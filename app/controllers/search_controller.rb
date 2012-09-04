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
    @blogs = blogs.where("title like ?", "%#{params[:title]}%").order('created_at DESC').limit(100)
  end

  def all
    if @user.nil?
      blogs = Blog
      notes = Note
    else
      blogs = @user.blogs
      notes = @user.notes
    end
    blogs = blogs.where("title like ?", "%#{params[:title]}%").includes(:user).order('comments_count DESC').limit(100)
    notes = notes.where("title like ?", "%#{params[:title]}%").includes(:user).order('comments_count DESC').limit(80)
    @all = (blogs | notes).sort_by{|x| x.comments_count}.reverse!
  end
end