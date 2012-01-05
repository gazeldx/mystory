class NotesController < ApplicationController

  def index
    @notes = Note.where(["user_id = ?", @user.id]).page(params[:page]).order("created_at DESC")
  end

  def create
    @note = Note.new(params[:note])
    @note.user_id = session[:id]
    if @note.save
      redirect_to :back, notice: t('note_post_succ')
    else
      render :new
    end
  end

  def show
    @note = Note.find(params[:id])
    @note_pre = Note.where(["user_id = ? AND created_at > ?", @user.id, @note.created_at]).order('created_at').first
    @note_next = Note.where(["user_id = ? AND created_at < ?", @user.id, @note.created_at]).order('created_at DESC').first
  end
end
