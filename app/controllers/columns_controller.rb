class ColumnsController < ApplicationController
  before_filter :super_admin, :except => :show
  skip_before_filter :url_authorize
  layout 'help'

  def show
    @column = Column.find(params[:id])
#    @blogs = @column.blogs.includes(:user).page(params[:page]).order("created_at DESC")
#    notes = @column.notes.includes(:user).page(params[:page]).order("created_at DESC")
#    @all = (@blogs | notes).sort_by{|x| x.created_at}.reverse!
    render :layout => 'portal'
  end

  def new
    @column = Column.new
  end

  def index
    @columns = Column.order('created_at')
  end

  def edit
    @column = Column.find(params[:id])
  end

  def create
    @column = Column.new(params[:column])
    if @column.save
      flash[:notice] = t'create_succ'
    else
      flash[:error] = t'taken', :w => @column.name
    end
    redirect_to columns_path
  end

  def update
    @column = Column.find(params[:id])
    if @column.update_attributes(params[:column])
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
    columns = Column.where(:user_id => session[:id]).order('created_at DESC')
    html = ''
    columns.each do |column|
      checkbox = "<input type='checkbox' name='columns' value=#{column.id}>"
      html += "#{checkbox}#{column.name}&nbsp;&nbsp;"
    end
    puts html
    html += "<input type='button' value='#{t'save'}' onclick='update_article_columns()'>"
    render :text => html
  end

  private
  def exchange_create_at
    m_c_at = @column.created_at
    @column.update_attribute('created_at', @column_t.created_at)
    @column_t.update_attribute('created_at', m_c_at)
    redirect_to columns_path
  end
end
