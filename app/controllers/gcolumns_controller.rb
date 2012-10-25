class GcolumnsController < ApplicationController
  before_filter :group_admin
  skip_before_filter :url_authorize
  layout 'help'

  def show
    @gcolumn = Gcolumn.find(params[:id])
#    @blogs = @gcolumn.blogs.includes(:user).page(params[:page]).order("created_at DESC")
#    notes = @column.notes.includes(:user).page(params[:page]).order("created_at DESC")
#    @all = (@blogs | notes).sort_by{|x| x.created_at}.reverse!
    render layout: 'portal'
  end

  def new
    @gcolumn = Gcolumn.new
  end

  def index
    @gcolumns = Gcolumn.order('created_at')
  end

  def edit
    @gcolumn = Gcolumn.find(params[:id])
  end

  def create
    @gcolumn = Gcolumn.new(params[:gcolumn])
    @gcolumn.group = @group
    puts "------------"
    puts @gcolumn.inspect
    if @gcolumn.save
      flash[:notice] = t'create_succ'
    else
      flash[:error] = t'taken', w: @gcolumn.name
    end
    redirect_to gcolumns_path
  end

  def update
    @gcolumn = Gcolumn.find(params[:id])
    if @gcolumn.update_attributes(params[:gcolumn])
      redirect_to edit_gcolumn_path, notice: t('update_succ')
    else
      render :edit
    end
  end

  def up
    @gcolumn = Gcolumn.find(params[:id])
    @gcolumn_t = Gcolumn.where("created_at < ?", @gcolumn.created_at).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @gcolumn = Gcolumn.find(params[:id])
    @gcolumn_t = Gcolumn.where("created_at > ?", @gcolumn.created_at).order('created_at').first
    exchange_create_at
  end
  
  private
  def exchange_create_at
    m_c_at = @gcolumn.created_at
    @gcolumn.update_attribute('created_at', @gcolumn_t.created_at)
    @gcolumn_t.update_attribute('created_at', m_c_at)
    redirect_to gcolumns_path
  end
end
