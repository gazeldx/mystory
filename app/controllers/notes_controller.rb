class NotesController < ApplicationController
  layout 'memoir'
  
  def index
    @note = Note.new
    @notes = Note.where(["user_id = ?", @user.id]).page(params[:page]).order("created_at DESC")
  end

  def new
    @note = Note.new
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
    #TODO change to max or min?
    @note_pre = @user.notes.where(["created_at > ?", @note.created_at]).order('created_at').first
    @note_next = @user.notes.where(["created_at < ?", @note.created_at]).order('created_at DESC').first
    @all_comments = (@note.notecomments | @note.rnotes.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
  end

  def edit
    @note = Note.find(params[:id])
    authorize @note
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      redirect_to note_path, notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to notes_path, notice: t('delete_succ')
  end

  def click_show_note
    @note = Note.find(params[:id])
    @note.content = summary_comment_style(@note, 3000)
    render json: @note.as_json()
  end

end
