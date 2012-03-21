class PhotosController < ApplicationController
  layout 'album'

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
      @all_comments = (@photo.photocomments | @photo.rphotos.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
    else
      render text: t('page_not_found')
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
