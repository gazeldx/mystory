class ColumnsController < ApplicationController
  skip_before_filter :url_authorize
  layout 'help'

  def show
    @column = Column.find(params[:id])
    render :layout => 'portal'
  end

  def new
    @column = Column.new
  end

  def index
    @columns = @user.columns.order('created_at')
  end

  def edit
    @column = Column.find(params[:id])
  end

  def create
    @column = Column.new(params[:column])
    @column.user_id = session[:id]
    if @column.save
      flash[:notice] = t'create_succ'
    else
      flash[:error] = t'taken', :w => @column.name
    end
    expire_fragment("columns_navigation_#{session[:id]}")
    redirect_to columns_path
  end

  def update
    @column = Column.find(params[:id])
    if @column.update_attributes(params[:column])
      expire_fragment("columns_navigation_#{session[:id]}")
      redirect_to edit_column_path, :notice => t('update_succ')
    else
      render :edit
    end
  end

  def up
    @column = Column.find(params[:id])
    @column_t = Column.where("created_at < ?", @column.created_at).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @column = Column.find(params[:id])
    @column_t = Column.where("created_at > ?", @column.created_at).order('created_at').first
    exchange_create_at
  end

  #  def destroy
  #    @column = Column.find(params[:id])
  #    if @column.roles.exists?
  #      flash[:error] = t'column.has_roles_when_delete'
  #    else
  #      @column.destroy
  #      flash[:notice] = t'delete_succ'
  #    end
  #    redirect_to columns_path
  #  end

  def query_user_columns
    all_columns = Column.where(:user_id => session[:id]).order('created_at')
    case params[:stype]
    when 'blog'
      article = Blog.find(params[:id])
    when 'note'
      article = Note.find(params[:id])
    end
    columns = article.columns.where(:user_id => session[:id])
    html = ''
    all_columns.each do |column|
      checked = columns.any?{|x| x==column} ? "checked='checked'" : ""
      checkbox = "<input type='checkbox' name='columns' value=#{column.id} #{checked}>"
      html += "#{checkbox}#{column.name}&nbsp;&nbsp;"
    end
    if all_columns.blank?
      html += "#{t'no_columns_tip'}"
    else
      html += "<input type='button' value='#{t'save'}' onclick='update_user_columns()'>"
    end
    html += "<a href='#{sub_site(session[:domain]) + new_column_path}' target='_blank'>#{t'column.new'}</a>"
    render :text => html
  end

  def query_article_editors    
    case params[:stype]
    when 'blog'
      article = Blog.find(params[:id])
    when 'note'
      article = Note.find(params[:id])
    end
    columns = article.columns.includes(:user)
    html = t'been_edited'
    columns.each_with_index do |column, i|
      user = column.user
      html += "<a href='#{site(user)}' target='_blank'>#{user.name[0..4]}</a>><a href='#{site(user) + column_path(column)}' target='_blank'>#{column.name[0..4]}</a>"
      unless i == columns.length - 1
        html += ",&nbsp;"
      end
    end
    render :text => html
  end

  def update_user_columns
    case params[:stype]
    when 'blog'
      class_name = Blog
      article = Blog.find(params[:id])
      article_columns = BlogsColumns
    when 'note'
      class_name = Note
      article = Note.find(params[:id])
      article_columns = ColumnsNotes
    end
    column_ids = article.columns.where(:user_id => session[:id]).select('id').map{|x| x.id}
    column_ids.each do |id|
      expire_fragment("editor_column_#{id}")
    end
    new_columns_count = article.columns_count
    unless column_ids.blank?
      article_columns.delete_all ["#{params[:stype]}_id = ? AND column_id IN (?)", article.id, column_ids]
      new_columns_count -= 1
    end
    unless params[:columns].to_s == ''
      _columns = params[:columns].split ','
      _columns.each do |k, v|
        article_columns.create(params[:stype] => article, :column => Column.find(k))
        expire_fragment("editor_column_#{k}")
      end
      new_columns_count += 1
    end
    class_name.update_all("columns_count = #{new_columns_count}", "id = #{article.id}") if new_columns_count != article.columns_count
    expire_fragment("columns_articles_#{session[:id]}")
    expire_fragment("editor_home_#{session[:id]}")    
    render :text => new_columns_count
  end

  private
  def exchange_create_at
    m_c_at = @column.created_at
    @column.update_attribute('created_at', @column_t.created_at)
    @column_t.update_attribute('created_at', m_c_at)
    redirect_to columns_path
  end
end
