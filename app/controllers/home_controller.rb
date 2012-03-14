class HomeController < ApplicationController
  def index
    if @user.nil?
      @notes_new = Note.order("created_at DESC").limit(20)
      @blogs_new = Blog.order("created_at DESC").limit(20)
      #TODO hotest blog and note
      @users = User.order("created_at DESC").limit(20)
      render layout: 'portal'
    else
      #This is old like douban.com style home page
      #      @notes = @user.notes.order("created_at DESC").limit(10)
      #      @blogs = @user.blogs.order("created_at DESC").limit(10)
      ##      @photos = @user.photos.order("id DESC").limit(7) can't write as these .Because album.rb has photo and photos.Why?
      #      @photos = Photo.where(:album_id => @user.albums).order("id DESC").limit(5)

      @photos = Photo.where(:album_id => @user.albums).order("id DESC").limit(5)
      t = params[:t]
      if t.nil?
        notes = @user.notes.limit(2)
        blogs = @user.blogs.limit(2)
        photos = Photo.where(:album_id => @user.albums).includes(:album).limit(20)
        @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!
      elsif t == 'note'
        @all = @user.notes.limit(50)
      elsif t == 'blog'
        @all = @user.blogs.limit(40)
      elsif t == 'photo'
        @all = Photo.where(:album_id => @user.albums).includes(:album).order('photos.id DESC').limit(50)
      elsif t == 'updated'
        notes = @user.notes.where("updated_at > created_at").limit(30)
        blogs = @user.blogs.where("updated_at > created_at").limit(30)
        @all = (notes | blogs).sort_by{|x| x.updated_at}.reverse!
      elsif t == 'recommend'
        rnotes = @user.rnotes.limit(30)
        rblogs = @user.rblogs.limit(15)
        @all = (rnotes | rblogs).sort_by{|x| x.created_at}.reverse!
      end
      render :user
    end
  end
end