class RolesController < ApplicationController
  before_filter :super_admin
  skip_before_filter :url_authorize
  layout 'help'
  
  def index
    @roles = Role.order('created_at')
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = t'create_succ'
    else
      flash[:error] = t'taken', :w => @role.name
    end
    redirect_to roles_path
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to edit_role_path, :notice => t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @role = Role.find(params[:id])
    if @role.users.exists?
      flash[:error] = t'role.has_users_when_delete'
    elsif @role.menus.exists?
      flash[:error] = t'role.has_menus_when_delete'
    else
      @role.destroy
      flash[:notice] = t'delete_succ'
    end
    redirect_to roles_path
  end

  #  def show
  #    @role = Role.find(params[:id])
  #    @users = @role.users.page(params[:page]).order("created_at DESC")
  #  end
  
  def assign_menus
    @role = Role.find(params[:id])
    @menus = @role.menus
    @all_menus = Menu.order("created_at DESC")
  end

  def do_assign_menus
    role = Role.find(params[:id])
    role.menus.destroy_all
    unless params[:menu].nil?
      params[:menu].each do |k|
        role.menus << Menu.find(k)
      end
    end
    redirect_to roles_path, :notice => t('succ', :w => t('assign_menus'))
  end
end
