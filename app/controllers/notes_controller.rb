class NotesController < ApplicationController
  layout 'memoir'
  include Archives
  
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
      send_weibo
      send_qq
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

  #TODO change to max or min?
  def show
    @note = Note.find(params[:id])
    if @note.user == @user
      @notecates = @user.notecates.order('created_at')
      @new_notes = @user.notes.order('created_at DESC').limit(6)
      @note_pre = @user.notes.where(["created_at > ?", @note.created_at]).order('created_at').first
      @note_next = @user.notes.where(["created_at < ?", @note.created_at]).order('created_at DESC').first
      comments = @note.notecomments
      @all_comments = (comments | @note.rnotes.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
      @comments_uids = comments.collect{|c| c.user_id}
      ids = @user.notes.select('id')
      @rnotes = @user.r_notes.where(id: ids).limit(6)
      cate_ids = @user.notes.where(["notecate_id = ?", @note.notecate_id]).select('id')
      @cate_rnotes = @user.r_notes.where(id: cate_ids).limit(5)
      if @cate_rnotes.size < 5
        @cate_notes = @user.notes.where(["notecate_id = ?", @note.notecate_id]).order('created_at DESC').limit(5 - @cate_rnotes.size)
      end
      archives_months_count
      if @m
        render mr, layout: 'm/portal'
      else
        render layout: 'note'
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
    flash[:notice] = t'delete_succ'
    if @m
      redirect_to notice_path
    else
      redirect_to notes_path
    end
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

  private
  def send_weibo
    if session[:atoken]
      begin
        oauth = weibo_auth
        str = "#{@note.title.to_s=='' ? '' : @note.title + ' - '}"
        data = "#{str}#{text_it_pure(@note.content)[0..130-str.size]}#{site(@user) + note_path(@note)}"
        Weibo::Base.new(oauth).update(data)
      rescue
        logger.warn("---Send_note_to_weibo note.id=#{@note.id} failed.Data is #{data} #{session[:atoken]} ")
      end
    end
  end

  def send_qq
    if session[:token]
      begin
        qq = Qq.new
        auth = qq.gen_auth(session[:token], session[:openid])
        text = text_it_pure(@note.content)
        url = site(@user) + note_path(@note)
        comment = text[0..40]
        summary = "...#{text[41..160]}"
        qq.add_share(auth, @note.title.to_s=='' ? @note.created_at.strftime(t'date_format') : @note.title, url, comment, summary, "", '1', site(@user), '', '')
      rescue
        logger.warn("---Send_note_to_qq note.id=#{@note.id} failed.Data is #{url}, #{comment}, #{summary} , #{auth} ")
      end
    end
  end
end
