class LikeController < ApplicationController
  layout 'like'

  def index
    following = Follow.where(["follower_id = ?", @user.id])
    following_ids = following.collect{|f| f.followable_id}
    following_ids << @user.id
    @note = Note.new
    t = params[:t]
    #TODO memoir updated show here?
    if t.nil?
      notes = Note.where(:user_id => following_ids).limit(30)
      blogs = Blog.where(:user_id => following_ids).limit(15)
      rnotes = Rnote.where(:user_id => following_ids).limit(30)
      rblogs = Rblog.where(:user_id => following_ids).limit(15)
      album_ids = Album.where(:user_id => following_ids)
      photos = Photo.where(:album_id => album_ids).includes(:album).limit(30)
      @all = (notes | rnotes | rblogs | blogs | photos).sort_by{|x| x.created_at}.reverse!
    elsif t == 'note'
      @all = Note.where(:user_id => following_ids).order('created_at DESC').limit(100)
    elsif t == 'blog'
      @all = Blog.where(:user_id => following_ids).order('created_at DESC').limit(50)
    elsif t == 'photo'
      album_ids = Album.where(:user_id => following_ids)
      @all = Photo.where(:album_id => album_ids).includes(:album).order('photos.id DESC').limit(50)
    elsif t == 'updated'
#      notes = @user.notes.where("updated_at > created_at").limit(30)
#      blogs = @user.blogs.where("updated_at > created_at").limit(30)
      notes = Note.where(:user_id => following_ids).where("updated_at > created_at").limit(30)
      blogs = Blog.where(:user_id => following_ids).where("updated_at > created_at").limit(30)
      @all = (notes | blogs).sort_by{|x| x.updated_at}.reverse!      
    elsif t == 'recommend'
      rnotes = Rnote.where(:user_id => following_ids).limit(30)
      rblogs = Rblog.where(:user_id => following_ids).limit(15)
      @all = (rnotes | rblogs).sort_by{|x| x.created_at}.reverse!
    end
  end
end
