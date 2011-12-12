class Admin::MenusController < Admin::BaseController
  def index
    #TODO ORDER
    @menus = Menu.where(["user_id = ?", session[:user_id]]).order('created_at')
  end

  def new
    @menu = Menu.new
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def create
    @menu = Menu.new(params[:menu])
    @menu.user_id=session[:user_id]
    if @menu.save
      redirect_to admin_menus_path,notice: t('create_succ')
    else
      render :new
    end
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update_attributes(params[:menu])
      redirect_to edit_admin_menu_path,notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to admin_menus_path,notice: t('delete_succ')
  end
  
  #@menu_target1=Menu.find_by_created_at(Menu.where(["user_id = ?", session[:user_id]]).maximum("created_at"))
  def up
    @menu = Menu.find(params[:id])    
    @menu_t=Menu.where(["user_id = ? AND created_at < ?", session[:user_id],@menu.created_at]).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @menu = Menu.find(params[:id])
    @menu_t=Menu.where(["user_id = ? AND created_at > ?", session[:user_id],@menu.created_at]).order('created_at').first
    exchange_create_at
  end

  private
  def exchange_create_at
    m_c_at=@menu.created_at
    @menu.update_attribute('created_at',@menu_t.created_at)
    @menu_t.update_attribute('created_at',m_c_at)
    redirect_to admin_menus_path
  end
end
