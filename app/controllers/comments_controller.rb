class CommentsController < ApplicationController
  layout 'memoir'

  def comments
    #TODO recemended not show as comment
    blogcomments = @user.blogcomments.includes(:blog => :user).order('updated_at DESC').limit(30)
    notecomments = @user.notecomments.includes(:note => :user).order('updated_at DESC').limit(30)
    photocomments = @user.photocomments.includes(:photo => [:album => :user]).order('updated_at DESC').limit(10)
    comments =  blogcomments | notecomments | photocomments

    #    memoir = Memoir.find_by_user_id(@user.id)
    #    unless memoir.nil?
    #      memoir_comments = memoir.memoircomments
    #      comments = comments | memoir_comments
    #    end

    @comments = comments.sort_by{|x| x.updated_at}.reverse!
    
    @view_comments_at = @user.view_comments_at
    if @user.id == session[:id]
      @user.update_attribute('view_comments_at', Time.now)
      @user.update_attribute('unread_comments_count', 0)
    end
  end

  def commented
    #TODO recemended not show as comment
    blog_ids = Blog.select("id").where("user_id = ?", @user.id)
    note_ids = Note.select("id").where("user_id = ?", @user.id)
    photo_ids = Photo.select("id").where(album_id: @user.albums)
    blogcomments = Blogcomment.where(blog_id: blog_ids).includes([:user, :blog]).order('updated_at DESC').limit(30)
    notecomments = Notecomment.where(note_id: note_ids).includes([:user, :note]).order('updated_at DESC').limit(30)
    photocomments = Photocomment.where(photo_id: photo_ids).includes([:user, :photo]).order('photocomments.updated_at DESC').limit(10)
    comments =  blogcomments | notecomments | photocomments

    memoir = Memoir.find_by_user_id(@user.id)
    unless memoir.nil?
      memoir_comments = memoir.memoircomments
      comments = comments | memoir_comments
    end

    @comments = comments.sort_by{|x| x.updated_at}.reverse!

    @view_commented_at = @user.view_commented_at
    if @user.id == session[:id]
      @user.update_attribute('view_commented_at', Time.now)
      @user.update_attribute('unread_commented_count', 0)
    end
  end

end