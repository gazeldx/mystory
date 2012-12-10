class SearchController < ApplicationController
  layout 'help'

  def index
  end

  def all
    if @user.nil?
      blogs = Blog.where("upper(title) like upper(?)", "%#{params[:title]}%").includes(:user).order('comments_count DESC').limit(100)
      notes = Note.where("upper(title) like upper(?)", "%#{params[:title]}%").includes(:user).order('comments_count DESC').limit(80)
    else
      blogs = @user.blogs.where("upper(content) like upper(?)", "%#{params[:title]}%").includes(:user).order('comments_count DESC').limit(100)
      notes = @user.notes.where("upper(content) like upper(?)", "%#{params[:title]}%").includes(:user).order('comments_count DESC').limit(80)
    end
    @all = (blogs | notes).sort_by{|x| x.comments_count}.reverse!
  end
end