class NotesController < ApplicationController
  layout 'memoir'
  
  def index
    @notes = @user.notes.page(params[:page]).order("created_at DESC")
    @notecates = @user.notecates.order('created_at')
#    default_category = Notecate.new
#    default_category.id = 0
#    default_category.name = t'default_notecate_name'
#    @notecates.unshift(default_category)
  end

  def new
    if session[:id] == @user.id
      @note = Note.new
      render mr, layout: 'm/portal' if @m
    else
      r404
    end
  end

  def create    
    @note = Note.new(params[:note])
    @note.user_id = session[:id]
    if params[:category_name].nil?
      create_proc
    else
      @category = Notecate.new
      @category.name = params[:category_name]
      @category.user_id = session[:id]
      if @category.save
        @note.notecate_id = @category.id
        create_proc
      else
        if @category.name == ""
          flash[:error] = t'notecate.name_must_notnull'
        else
          flash[:error] = t('taken', w: @category.name)
        end
        _render :new
      end
    end
  end

  def create_proc
    build_tags @note
    if @note.save
      flash[:notice2] = t'note_post_succ'
      redirect_to note_path(@note)
    else
      _render :new
    end
  end

  def build_tags(item)
    unless params[:tags].to_s == ''
      tags_a = params[:tags].split ' '
      tags_a.uniq.reverse.each do |tag|
        _tag = item.notetags.build
        _tag.name = tag
      end
    end
  end

  def show
    @note = Note.find(params[:id])
    if @note.user == @user
      #TODO change to max or min?
      @notecates = @user.notecates.order('created_at')
      @note_pre = @user.notes.where(["created_at > ?", @note.created_at]).order('created_at').first
      @note_next = @user.notes.where(["created_at < ?", @note.created_at]).order('created_at DESC').first
      comments = @note.notecomments
      @all_comments = (comments | @note.rnotes.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
      @comments_uids = comments.collect{|c| c.user_id}
      ids = @user.notes.select('id')
      @rnotes = @user.r_notes.where(id: ids).limit(5)
      if @m
        render mr, layout: 'm/portal'
      else
        render layout: 'memoir_share'
      end
    else
      r404
    end
  end

  def edit
    @note = Note.find(params[:id])
    @tags = @note.notetags.map { |t| t.name }.join(" ")
    authorize @note
    render mr, layout: 'm/portal' if @m
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      @note.notetags.destroy_all
      build_tags @note
      @note.update_attributes(params[:note])
      flash[:notice2] = t'update_succ'
      redirect_to note_path
    else
      _render :edit
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

  def archives
    #ISSUE to_char maybe only work in postgresql
    @items = @user.notes.select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')").order('t_date DESC')
  end

  def month
    @notes = @user.notes.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).page(params[:page])
    archives
  end

end
