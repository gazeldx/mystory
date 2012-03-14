class PhotocommentsController < ApplicationController

  def create
    @photo = Photo.find(params[:photo_id])
    @photocomment = @photo.photocomments.new(params[:photocomment])
    @photocomment.user_id = session[:id]
    @photocomment.save
    flash[:notice] = t'comment_succ'
    redirect_to album_photo_path(@photo.album, @photo) + "#add_comment"
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.photocomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end
  
end
