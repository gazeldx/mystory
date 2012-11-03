class PhotocommentsController < ApplicationController
  include Recommend, Comment
  
  def create
    @photo = Photo.find(params[:photo_id])
    comments = @photo.photocomments
    if params[:reply_user_id].to_s != '' and @photo.album.user_id == session[:id]
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:photocomment][:body]
#      Photocomment.update_all({:body => body}, {:id => comment.id})
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'

      reply_user = User.find(params[:reply_user_id])
      reply_user.update_attribute('unread_comments_count', reply_user.unread_comments_count + 1)
    else
      if comments.collect{|c| c.user_id}.include?(session[:id])
        comment = comments.find_by_user_id(session[:id])
        body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' '
        if params[:reply_user_id].to_s != ''
          body = body + "repU#{params[:reply_user_id]} " + params[:photocomment][:body]
          flash[:notice] = t'reply_succ'
        else
          body += params[:photocomment][:body]
          flash[:notice] = t'add_comment_succ'
        end
        comment.update_attribute('body', body)
      else
        @photocomment = comments.new(params[:photocomment])
        @photocomment.user_id = session[:id]
        if params[:reply_user_id].to_s != ''
          @photocomment.body = "repU#{params[:reply_user_id]} " + @photocomment.body
        end
        @photocomment.save
        Photo.update_all({:comments_count => @photo.comments_count + 1}, {:id => @photo.id})
        flash[:notice] = t'comment_succ'
      end
      writer = @photo.album.user
      writer.update_attribute('unread_commented_count', writer.unread_commented_count + 1) if writer.id != session[:id]
    end
    if params[:comment_and_recommend]
      _r = Rphoto.find_by_user_id_and_photo_id(session[:id], @photo.id)
      save_rphoto(@photo, params[:photocomment][:body]) if _r.nil?
      flash[:notice] = flash[:notice] + t('photo_recommended')
    end
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.photocomments.find(params[:id])
    @comment.destroy
    Photo.update_all({:comments_count => @photo.comments_count - 1}, {:id => @photo.id})
    flash[:notice] = t('delete_succ1', :w => t('comment'))
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end

  def like
    comment = Photocomment.find(params[:id])
    like_it comment
    render json: comment.as_json
  end
  
end
