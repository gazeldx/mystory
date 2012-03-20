class NotecommentsController < ApplicationController

  def create
    @note = Note.find(params[:note_id])
    @notecomment = @note.notecomments.new(params[:notecomment])
    @notecomment.user_id = session[:id]
    @notecomment.save
    flash[:notice] = t'comment_succ'
    redirect_to note_path(@note) + "#notice"
  end

  def destroy
    @note = Note.find(params[:note_id])
    @comment = @note.notecomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to note_path(@note) + "#notice"
  end
  
end
