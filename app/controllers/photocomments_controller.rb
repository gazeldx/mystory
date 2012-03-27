class PhotocommentsController < ApplicationController

  def create
    @photo = Photo.find(params[:photo_id])
    comments = @photo.photocomments
    if params[:reply_user_id] != ''
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:photocomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'
    elsif comments.collect{|c| c.user_id}.include?(session[:id])
      comment = comments.find_by_user_id(session[:id])
      body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' ' + params[:photocomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'add_comment_succ'
    else
      @photocomment = comments.new(params[:photocomment])
      @photocomment.user_id = session[:id]
      @photocomment.save
      flash[:notice] = t'comment_succ'
    end
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.photocomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end
  
end
