class NotecommentsController < ApplicationController

  def create
    @note = Note.find(params[:note_id])
    comments = @note.notecomments
    if params[:reply_user_id] != ''
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:notecomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'
    elsif comments.collect{|c| c.user_id}.include?(session[:id])
      comment = comments.find_by_user_id(session[:id])
      body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' ' + params[:notecomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'add_comment_succ'
    else
      @notecomment = comments.new(params[:notecomment])
      @notecomment.user_id = session[:id]
      @notecomment.save
      Note.update_all("comments_count = #{@note.comments_count + 1}", "id = #{@note.id}")
      flash[:notice] = t'comment_succ'
    end
    redirect_to note_path(@note) + "#notice"
  end

  def destroy
    @note = Note.find(params[:note_id])
    @comment = @note.notecomments.find(params[:id])
    @comment.destroy
    Note.update_all("comments_count = #{@note.comments_count - 1}", "id = #{@note.id}")
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to note_path(@note) + "#notice"
  end
  
end
