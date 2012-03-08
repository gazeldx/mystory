class HomeController < ApplicationController
  def index
    if @user.nil?
      @notes_new = Note.order("created_at DESC").limit(20)
      @blogs_new = Blog.order("created_at DESC").limit(20)
      #TODO hotest blog and note
      @users = User.order("created_at DESC").limit(20)
      render layout: 'portal'
    else
      @notes = @user.notes.order("created_at DESC").limit(10)
      @blogs = @user.blogs.order("created_at DESC").limit(10)
#      @photos = @user.photos.order("id DESC").limit(7) can't write as these .Because album.rb has photo and photos.Why?
      @photos = Photo.where(:album_id => @user.albums).order("id DESC").limit(5)
      render :user
    end
  end
end