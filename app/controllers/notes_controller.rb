class NotesController < ApplicationController
  before_filter :super_admin, :only => [:assign_columns, :do_assign_columns]
  before_filter :group_admin, :only => [:assign_gcolumns, :do_assign_gcolumns]
  skip_before_filter :url_authorize, :only => [:assign_columns, :do_assign_columns]
  layout 'memoir'
  cache_sweeper :note_sweeper
  
  def index
    @rids = @user.rnotes.select('note_id').map{|x| x.note_id}
    @notes = @user.notes.includes([:notetags, :notecate]).where(:is_draft => false).page(params[:page]).order("created_at DESC")
    @notecates = @user.notecates.order('created_at')
  end

  def new
    if session[:id] == @user.id
      @note = Note.new
      if @m
        render mr, :layout => 'm/portal'
      else
        render :layout => 'new'
      end
    else
      r404
    end
  end

  def create    
    @note = Note.new(params[:note])
    @note.user_id = session[:id]
    @note.replied_at = Time.now
    @note.is_draft = true if params[:save_as_draft]
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
          flash[:error] = t('taken', :w => @category.name)
        end
        _render :new
      end
    end
  end

  def create_proc
    build_tags @note
    if @note.save
      user = @note.user
      user.update_attribute('notes_count', user.notes_count + 1)
      if @note.is_draft
        flash[:notice2] = t'note_drafted_succ'
      else
        flash[:notice2] = t'note_post_succ'
      end
      ping_search_engine(@note)
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
      tags_a.uniq.each do |tag|
        _tag = item.notetags.build
        _tag.name = tag
      end
    end
  end

  #TODO change to max or min?
  def show
    @note = Note.find(params[:id])
    if @note.is_draft && @user.id != session[:id]
      redirect_to site @user
    else
      if @note.user == @user
        add_view_count
        @notecates = @user.notecates.order('created_at')
        
        @note_pre = @user.notes.where(["notecate_id = ? AND created_at > ? AND is_draft = false", @note.notecate_id, @note.created_at]).order('created_at').first
        @note_next = @user.notes.where(["notecate_id = ? AND created_at < ? AND is_draft = false", @note.notecate_id, @note.created_at]).order('created_at DESC').first
        
        @all_comments = @note.notecomments.order('likecount DESC, created_at')
        @comments_uids = @all_comments.collect{|c| c.user_id}
        
        cate_notes_ids = @user.notes.where(:is_draft => false).where(["notecate_id = ?", @note.notecate_id]).select('id')
        #TODO limit 4 make it a bug
        @all_cate_rnotes = @user.r_notes.where(id: cate_notes_ids).order('created_at DESC').limit(4)
        @cate_rnotes = @all_cate_rnotes - [@note_pre, @note_next, @note]
        not_in_notes_ids = @cate_rnotes.collect{|c| c.id} << @note.id
        not_in_notes_ids = not_in_notes_ids << @note_pre.id unless @note_pre.nil?
        not_in_notes_ids = not_in_notes_ids << @note_next.id unless @note_next.nil?
        if @cate_rnotes.size < 4
          @cate_notes = @user.notes.where(["notecate_id = ? AND is_draft = false AND id not in (?)", @note.notecate_id, not_in_notes_ids]).order('created_at DESC').limit(4 - @cate_rnotes.size)
        end
        
        if @m
          render mr, :layout => 'm/portal'
        else
          render :layout => 'note'
        end
      else
        r404
      end
    end
  end

  def edit
    @note = Note.find(params[:id])
    @tags = @note.notetags.map { |t| t.name }.join(" ")
    authorize @note
    if @m
      render mr, :layout => 'm/portal'
    else
      render :layout => 'new'
    end
  end

  def update
    @note = Note.find(params[:id])
    @note.is_draft = params[:save_as_draft] ? true : false
    if @note.update_attributes(params[:note])
      @note.notetags.destroy_all
      build_tags @note
      @note.update_attributes(params[:note])
      if @note.is_draft
        flash[:notice2] = t'note_drafted_update_succ'
      else
        flash[:notice2] = t'update_succ'
      end
      redirect_to note_path
    else
      _render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    user = @note.user
    @note.destroy
    user.update_attribute('notes_count', user.notes_count - 1)
    flash[:notice] = t'delete_succ'
    if @m
      redirect_to notice_path
    else
      redirect_to notes_path
    end
  end

  def click_show_note
    @note = Note.find(params[:id])
    add_view_count
    @note.content = summary_style(@note, 3000)
    render json: @note.as_json()
  end

  #  def archives
  #    #ISSUE to_char maybe only work in postgresql
  #    @items = @user.notes.where(:is_draft => false).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')").order('t_date DESC')
  #  end

  #  def month
  #    @notes = @user.notes.includes([:notetags, :notecate]).where("to_char(created_at, 'YYYYMM') = ? and is_draft = false", params[:month]).page(params[:page])
  #    archives
  #  end

  def assign_columns
    @note = Note.find(params[:id])
    @columns = @note.columns
    @all_columns = Column.order("created_at")
    render :layout => 'help'
  end

  def do_assign_columns
    note = Note.find(params[:id])
    columns = note.columns
    columns.each do |column|
      expire_fragment("portal_column_#{column.id}")
    end
    columns.destroy_all
    unless params[:column].nil?
      params[:column].each do |k, v|
        note.columns << Column.find(k)
        expire_fragment("portal_column_#{k}")
      end
    end
    expire_fragment('columns_articles')
    redirect_to column_blogs_path, :notice => t('succ', :w => t('assign_columns'))
  end

  def assign_gcolumns
    @note = Note.find(params[:id])
    if @group.users.include? @note.user
      @columns = @note.gcolumns.where(:group_id => @group.id)
      @all_columns = @group.gcolumns.order("created_at")
      render :layout => 'help'
    else
      r404
    end
  end

  def do_assign_gcolumns
    note = Note.find(params[:id])
    gcolumn_ids = note.gcolumns.where(:group_id => @group.id).select('id').map{|x| x.id}
    GcolumnsNotes.delete_all ["note_id = ? AND gcolumn_id in (?)", note.id, gcolumn_ids]
    unless params[:column].nil?
      params[:column].each do |k, v|
        GcolumnsNotes.create(note: note, :gcolumn => Gcolumn.find(k), :created_at => Time.now)
      end
    end
    redirect_to assign_gcolumns_note_path(note), :notice => t('succ', :w => t('assign_columns'))
  end

  private
  def send_weibo
    if weibo_active? and @note.is_draft==false and Rails.env.production? and params[:sync_weibo] != "false"
      begin
        str = "#{@note.title.to_s=='' ? '' : @note.title + ' - '}"
        data = "#{str}#{text_it_pure(@note.content)[0..130-str.size]}#{site(@user) + note_path(@note)}"
        weibo_auth.statuses.update(data)
      rescue
        logger.warn("---Send_note_to_weibo note.id=#{@note.id} failed.Data is #{data} #{session[:atoken]} ")
      end
    end
  end

  def send_qq
    if qq_active? and @note.is_draft==false and Rails.env.production? and params[:sync_qq] != "false"
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

  def add_view_count
    @note.views_count = @note.views_count + 1
    Note.update_all("views_count = #{@note.views_count}", "id = #{@note.id}")
  end
end
