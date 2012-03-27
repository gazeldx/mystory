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
      flash[:notice2] = t'note_post_succ'
      redirect_to note_path(@note)
    else
      render :new
    end
  end

  def show
    @note = Note.find(params[:id])
    if @note.user == @user
      #TODO change to max or min?
      @note_pre = @user.notes.where(["created_at > ?", @note.created_at]).order('created_at').first
      @note_next = @user.notes.where(["created_at < ?", @note.created_at]).order('created_at DESC').first
      comments = @note.notecomments
      @all_comments = (comments | @note.rnotes.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
      @comments_uids = comments.collect{|c| c.user_id}
    else
      render text: t('page_not_found')
    end
  end

  def edit
    @note = Note.find(params[:id])
    authorize @note
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice2] = t'update_succ'
      redirect_to note_path
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
