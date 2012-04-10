class HomeController < ApplicationController

  def index
    if @user.nil?
      @notes_new = Note.includes(:user).order("created_at DESC").limit(13)
      @blogs_new = Blog.includes(:user).order("created_at DESC").limit(16)
      @photos = Photo.includes(:album => :user).limit(16).order('id desc').uniq {|s| s.album_id}
      render layout: 'portal'
    else
      @photos = Photo.where(album_id: @user.albums).limit(5).order('id desc')

      t = params[:t]
      if t.nil?
        notes = @user.notes.limit(30)
        blogs = @user.blogs.limit(10)
        photos = Photo.where(album_id: @user.albums).includes(:album).limit(15).order('id desc')
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
        @all = Photo.where(album_id: @user.albums).includes(:album).limit(50).order('id desc')
      elsif t == 'updated'
        notes = @user.notes.where("updated_at > created_at").limit(30)
        blogs = @user.blogs.where("updated_at > created_at").limit(30)
        all_ = notes | blogs
        memoir = @user.memoir
        all_ << memoir unless memoir.nil?
        @all = all_.sort_by{|x| x.updated_at}.reverse!
      elsif t == 'recommend'
        rnotes = @user.rnotes.includes(:note => :user).limit(30)
        rblogs = @user.rblogs.includes(:blog => :user).limit(15)
        rphotos = @user.rphotos.includes(:photo => [:album => :user]).limit(10)
        @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
      end

      ids = @user.blogs.select('id')
      @rblogs = @user.r_blogs.where(id: ids).limit(5)

      render :user
    end
  end
end

class Array
  def uniq_by(&blk)
    transforms = []
    self.select do |el|
      should_keep = !transforms.include?(t=blk[el])
      transforms << t
      should_keep
    end
  end
end
