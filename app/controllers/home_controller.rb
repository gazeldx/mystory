class HomeController < ApplicationController
  def index
    if @user.nil?
      @notes_new = Note.order("created_at DESC").limit(20)
      @blogs_new = Blog.order("created_at DESC").limit(20)
      #TODO hotest blog and note
      @users = User.order("created_at DESC").limit(20)
      render layout: 'portal'
    else
      @photos = Photo.where(album_id: @user.albums).order("id DESC").limit(5)
      t = params[:t]
      if t.nil?
        notes = @user.notes.limit(30)
        blogs = @user.blogs.limit(10)
        photos = Photo.where(album_id: @user.albums).includes(:album).limit(20)
        all_ = notes | blogs | photos
        memoir = @user.memoir
        unless memoir.nil?
          memoir.created_at = memoir.updated_at
          all_ << memoir
        end
        @all = all_.sort_by{|x| x.created_at}.reverse!
      elsif t == 'note'
        @all = @user.notes.limit(50)
      elsif t == 'blog'
        @all = @user.blogs.limit(40)
      elsif t == 'photo'
        @all = Photo.where(album_id: @user.albums).includes(:album).order('photos.id DESC').limit(50)
      elsif t == 'updated'
        notes = @user.notes.where("updated_at > created_at").limit(30)
        blogs = @user.blogs.where("updated_at > created_at").limit(30)
        all_ = notes | blogs
        memoir = @user.memoir
        all_ << memoir unless memoir.nil?
        @all = all_.sort_by{|x| x.updated_at}.reverse!
      elsif t == 'recommend'
        rnotes = @user.rnotes.limit(30)
        rblogs = @user.rblogs.limit(15)
        rphotos = @user.rphotos.limit(10)
        @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
      end
      render :user
    end
  end
end