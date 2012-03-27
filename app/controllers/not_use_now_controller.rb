class NowController < ApplicationController
#  layout 'like'

  def index
    @photos = Photo.where(:album_id => @user.albums).order("id DESC").limit(5)
    t = params[:t]
    if t.nil?
      notes = @user.notes.limit(30)
      blogs = @user.blogs.limit(15)
      photos = Photo.where(:album_id => @user.albums).includes(:album).limit(20)
      @all = (notes | blogs | photos).sort_by{|x| x.created_at}.reverse!
    elsif t == 'note'
      @all = @user.notes.order('created_at DESC').limit(50)
    elsif t == 'blog'
      @all = @user.blogs.order('created_at DESC').limit(40)
    elsif t == 'photo'
      @all = Photo.where(:album_id => @user.albums).includes(:album).order('photos.id DESC').limit(50)
    elsif t == 'recommend'
      rnotes = @user.rnotes.limit(30)
      rblogs = @user.rblogs.limit(15)
      @all = (rnotes | rblogs).sort_by{|x| x.created_at}.reverse!
    end
  end
end
