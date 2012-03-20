class LikeController < ApplicationController
  layout 'like'

  def index
    following = Follow.where(["follower_id = ?", @user.id])
    following_ids = following.collect{|f| f.followable_id}
    following_ids << @user.id
    @note = Note.new
    t = params[:t]
    if t.nil?
      notes = Note.where(user_id: following_ids).limit(30)
      blogs = Blog.where(user_id: following_ids).limit(15)
      album_ids = Album.where(user_id: following_ids)
      photos = Photo.where(album_id: album_ids).includes(:album).limit(30)
      rnotes = Rnote.where(user_id: following_ids).limit(30)
      rblogs = Rblog.where(user_id: following_ids).limit(15)
      rphotos = Rphoto.where(user_id: following_ids).limit(8)
      all_ = notes | blogs | photos | rnotes | rblogs | rphotos
      memoirs = Memoir.where(user_id: following_ids)
      unless memoirs.blank?
        memoirs.each do |memoir|
          memoir.created_at = memoir.updated_at
        end
        all_ = all_ | memoirs
      end
      @all = all_.sort_by{|x| x.created_at}.reverse!
    elsif t == 'note'
      @all = Note.where(user_id: following_ids).order('created_at DESC').limit(100)
    elsif t == 'blog'
      @all = Blog.where(user_id: following_ids).order('created_at DESC').limit(50)
    elsif t == 'photo'
      album_ids = Album.where(user_id: following_ids)
      @all = Photo.where(album_id: album_ids).includes(:album).order('photos.id DESC').limit(50)
    elsif t == 'updated'
      notes = Note.where(user_id: following_ids).where("updated_at > created_at").limit(30)
      blogs = Blog.where(user_id: following_ids).where("updated_at > created_at").limit(30)
      all_ = notes | blogs
      memoirs = Memoir.where(user_id: following_ids)
      unless memoirs.blank?
        all_ = all_ | memoirs
      end
      @all = all_.sort_by{|x| x.updated_at}.reverse!
    elsif t == 'recommend'
      rnotes = Rnote.where(user_id: following_ids).limit(30)
      rblogs = Rblog.where(user_id: following_ids).limit(20)
      rphotos = Rphoto.where(user_id: following_ids).limit(8)
      @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
    end
  end
end
