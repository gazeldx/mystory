class PhotosController < ApplicationController
  layout 'album'

  def index
    if @user.nil?
      photos = Photo.includes(:album => :user).limit(30).order('id desc')
      rphotos = Rphoto.includes(:photo => [:album => :user]).limit(50).order('id desc').uniq {|s| s.photo_id}
      all = photos | rphotos
      @all = all.sort_by{|x| x.created_at}.reverse!
      render 'portal' , layout: 'help'
    else
      @photos = Photo.where(album_id: @user.albums).includes(:album).limit(50).order('id desc')
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @album = @photo.album
    if @album.user == @user
      @photo_new = Photo.where(["album_id = ? AND created_at > ?", @album.id, @photo.created_at]).order('created_at').first
      @photo_old = Photo.where(["album_id = ? AND created_at < ?", @album.id, @photo.created_at]).order('created_at DESC').first
      @album.photos.each_with_index { |x, i|
        if x == @photo
          @photo_position = i + 1
          break
        end
      }
      comments = @photo.photocomments
      @all_comments = (comments | @photo.rphotos.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
      @comments_uids = comments.collect{|c| c.user_id}
      render layout: 'album_share'
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
      if @album.photos.size == 1
        @album.update_attribute(:photo_id, @photo.id)
      end
      redirect_to album_path(@album), notice: t('photo_upload_succ')
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
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    # Can this be auto updated?
    @photo.album.update_attribute(:photo_id, nil) if (@photo.album.photo_id == @photo.id)
    @photo.destroy
    redirect_to album_path(@photo.album), notice: t('delete_succ')
  end
end
