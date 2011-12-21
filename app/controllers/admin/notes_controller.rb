class Admin::NotesController < Admin::BaseController
  def index
    @notes = Note.where(["user_id = ?", session[:id]]).order('created_at DESC')
  end

  def new
    @note = Note.new
  end

  def edit
    @note = Note.find(params[:id])
  end

  def create
    @note = Note.new(params[:note])
    @note.user_id = session[:id]
    if @note.save
      redirect_to admin_notes_path, notice: t('create_succ')
    else
      render :new
    end
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      redirect_to edit_admin_note_path, notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to admin_notes_path, notice: t('delete_succ')
  end
end
