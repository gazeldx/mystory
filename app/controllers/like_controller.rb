class LikeController < ApplicationController
  layout 'like'

  def index
    following = Follow.where(["follower_id = ?", @user.id])
    following_ids = following.collect{|f| f.followable_id}
    following_ids << @user.id
#    @note = Note.new
    t = params[:t]
    if t.nil?
      notes = Note.where(user_id: following_ids).limit(30).order('id desc')
      blogs = Blog.where(user_id: following_ids).limit(15).order('created_at desc')
      album_ids = Album.where(user_id: following_ids)
      photos = Photo.where(album_id: album_ids).includes(:album).limit(20).order('photos.id desc')
      rnotes = Rnote.where(user_id: following_ids).limit(15).order('id desc')
      rblogs = Rblog.where(user_id: following_ids).limit(20).order('id desc')
      rphotos = Rphoto.where(user_id: following_ids).limit(10).order('id desc')
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
      @all = Note.where(user_id: following_ids).limit(50).order('id desc')
    elsif t == 'blog'
      @all = Blog.where(user_id: following_ids).limit(40).order('created_at desc')
    elsif t == 'photo'
      album_ids = Album.where(user_id: following_ids)
      @all = Photo.where(album_id: album_ids).includes(:album).limit(50).order('photos.id desc')
    elsif t == 'updated'
      notes = Note.where(user_id: following_ids).where("updated_at > created_at").limit(30).order('updated_at desc')
      blogs = Blog.where(user_id: following_ids).where("updated_at > created_at").limit(30).order('updated_at desc')
      all_ = notes | blogs
      memoirs = Memoir.where(user_id: following_ids)
      unless memoirs.blank?
        all_ = all_ | memoirs
      end
      @all = all_.sort_by{|x| x.updated_at}.reverse!
    elsif t == 'recommend'
      rnotes = Rnote.where(user_id: following_ids).limit(30).order('id desc')
      rblogs = Rblog.where(user_id: following_ids).limit(20).order('id desc')
      rphotos = Rphoto.where(user_id: following_ids).limit(8).order('id desc')
      @all = (rnotes | rblogs | rphotos).sort_by{|x| x.created_at}.reverse!
    end
  end
end
