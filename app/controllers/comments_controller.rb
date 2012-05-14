class CommentsController < ApplicationController
  layout 'memoir'

  def commented
    #TODO recemended not show as comment
    blog_ids = Blog.select("id").where("user_id = ?", @user.id)
    note_ids = Note.select("id").where("user_id = ?", @user.id)
    photo_ids = Photo.select("id").where(album_id: @user.albums)
    blogcomments = Blogcomment.where(blog_id: blog_ids).includes([:user, :blog])
    notecomments = Notecomment.where(note_id: note_ids).includes([:user, :note])
    photocomments = Photocomment.where(photo_id: photo_ids).includes([:user, :photo])
    comments =  blogcomments | notecomments | photocomments

    memoir = Memoir.find_by_user_id(@user.id)
    unless memoir.nil?
      memoir_comments = memoir.memoircomments
      comments = comments | memoir_comments
    end

    @comments = comments.sort_by{|x| x.updated_at}.reverse!
  end

  def comments
    #TODO recemended not show as comment    
    blogcomments = @user.blogcomments.includes(:blog)
    notecomments = @user.notecomments.includes(:note)
    photocomments = @user.photocomments.includes(:photo => [:album => :user])
    comments =  blogcomments | notecomments | photocomments

    memoir = Memoir.find_by_user_id(@user.id)
    unless memoir.nil?
      memoir_comments = memoir.memoircomments
      comments = comments | memoir_comments
    end
    
    @comments = comments.sort_by{|x| x.updated_at}.reverse!
  end

end