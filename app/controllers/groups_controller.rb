class GroupsController < ApplicationController
  layout 'help'
  skip_before_filter :url_authorize
  before_filter :super_admin, :only => [:new, :create, :edit, :update, :update_group_users_count, :group_index]

  def group_index
    @groups = Group.order('member_count')
    puts @groups.inspect
  end

  def new
    @_group = Group.new
  end

  def edit
    @_group = Group.find(params[:id])
  end

  def create
    @_group = Group.new(params[:group])
    if @_group.save
      flash[:notice] = t'create_succ'
      redirect_to new_group_path
    else
#      flash[:error] = t'taken', w: @group.name
      render :new
    end
  end

  def update
    @_group = Group.find(params[:id])
    if @_group.update_attributes(params[:group])
      flash[:notice] = t'update_succ'
      redirect_to sub_site('group')
    else
      render :edit
    end
  end

  def update_group_users_count
    groups = Group.all
    groups.each do |group|
      group.update_attribute('member_count', group.users.count)
    end
  end
end
