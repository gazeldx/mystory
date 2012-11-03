class MenusController < ApplicationController
  before_filter :super_admin
  skip_before_filter :url_authorize
  layout 'help'

  def new
    @menu = Menu.new
  end

  def index
    @menus = Menu.order('created_at')
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def create
    @menu = Menu.new(params[:menu])
    if @menu.save
      flash[:notice] = t'create_succ'
    else
      flash[:error] = t'taken', :w => @menu.name
    end
    redirect_to menus_path
  end

  def update
    @menu = Menu.find(params[:id])
    if @menu.update_attributes(params[:menu])
      redirect_to edit_menu_path, :notice => t('update_succ')
    else
      render :edit
    end
  end

#  def destroy
#    @menu = Menu.find(params[:id])
#    if @menu.roles.exists?
#      flash[:error] = t'menu.has_roles_when_delete'
#    else
#      @menu.destroy
#      flash[:notice] = t'delete_succ'
#    end
#    redirect_to menus_path
#  end

#  def show
#    @menu = Menu.find(params[:id])
#    @users = @menu.roles.order("created_at DESC")
#  end
end
