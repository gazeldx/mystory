class PhotosController < ApplicationController
  layout 'album'

  def index
    if @user.nil?
      photos = Photo.includes(:album => :user).limit(30).order('id desc')
      rphotos = Rphoto.includes(:photo => [:album => :user]).limit(50).order('id desc').uniq {|s| s.photo_id}
      @intersection = rphotos.map{|x| x.photo_id} & photos.map{|x| x.id}
      all = photos | rphotos
      @all = all.sort_by{|x| x.created_at}.reverse!
      render 'portal' , :layout => 'portal_photos'
    else
      @photos = Photo.where(:album_id => @user.albums).includes(:album).limit(50).order('id desc')
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @album = @photo.album
    if @album.user == @user
      add_view_count
      @photo_new = Photo.where(["album_id = ? AND created_at > ?", @album.id, @photo.created_at]).order('created_at').first
      @photo_old = Photo.where(["album_id = ? AND created_at < ?", @album.id, @photo.created_at]).order('created_at DESC').first
      @photos = @album.photos.order('id DESC')
      @photos.each_with_index { |x, i|
        if x == @photo
          @photo_position = i + 1
          break
        end
      }
      @all_comments = @photo.photocomments.order('likecount DESC, created_at')
      @comments_uids = @all_comments.collect{|c| c.user_id}
      render :layout => 'album_share'
    else
      r404
    end
  end

  def new
    @album = Album.find(params[:album_id])
    @photo = @album.photos.build
  end

  def create
    @album = Album.find(params[:album_id])
    @photo = @album.photos.build(params[:photo])
    if @photo.save
      @album.update_attribute(:photo_id, @photo.id) if @album.photos.size == 1
      expire_cache
      redirect_to album_path(@album), :notice => t('photo_upload_succ')
    else
      render :new
    end
  end

  def modify
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      #      TODO Don't generate every album cover every pic.Only use it.
      @photo.album.update_attribute(:photo_id, @photo.id) if ("1" == params[:setascover])
      head :ok
    else
      render json: @photo.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    # Can this be auto updated?
    @photo.album.update_attribute(:photo_id, nil) if (@photo.album.photo_id == @photo.id)
    @photo.destroy
    expire_cache
    redirect_to album_path(@photo.album), :notice => t('delete_succ')
  end

  def m_new
    if session[:id] == @user.id
      @photo = Photo.new
      render mr, :layout => 'm/portal'
    else
      r404
    end
  end

  def m_upload_photo
    @album = @user.albums.first(:order => "id")
    if @album.nil?
      @album = Album.new
      @album.name = t'default_album_name'
      @album.user_id = session[:id]
      @album.save
    end
    @photo = @album.photos.build(params[:photo])
    if @photo.save
      @album.update_attribute(:photo_id, @photo.id) if @album.photos.size == 1
      expire_cache
      render mn('photo_uploaded'), :layout => 'm/portal'
    else
      render mn('m_new'), :layout => 'm/portal'
    end
  end

  def m_update_photo
    @photo = Photo.find(params[:photo][:id])
    @photo.update_attributes(params[:photo])
    redirect_to upload_photo_path, :notice => t('photo_updated_succ')
  end

  private
  def expire_cache
    expire_fragment("user_home_photos_#{session[:id]}")
  end

  def add_view_count
    @photo.views_count = @photo.views_count + 1
    Photo.update_all({:views_count => @photo.views_count}, {:id => @photo.id})
  end

end
