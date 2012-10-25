class GroupsController < ApplicationController
  layout 'help'
  skip_before_filter :url_authorize
  before_filter :super_admin, :only => [:new, :create, :edit, :update, :update_group_users_count, :group_index, :assign_admin, :do_assign_admin, :do_add_user_by_super]

  def group_index
    @groups = Group.order('member_count DESC')
  end

  def new
    @_group = Group.new
  end

  def edit
    @_group = Group.find(params[:id])
  end

#  def edit_about
##    @_group = Group.find_by_domain(@group.domain)
#    render layout: 'help'
#  end

  def create
    puts params[:group].inspect
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

  def update_byuser
    if @group.update_attributes(params[:group])
      flash[:notice] = t'update_succ'
      redirect_to site(@group) + about_path
    else
      render :edit_about
    end
  end

  def do_add_user_by_super
    group = Group.find(params[:group_id])
    user = User.find(params[:user_id])
    GroupsUsers.create(group: group, user: user, created_at: Time.now)
  end

  def do_assign_admin
    group_user = GroupsUsers.find_by_group_id_and_user_id(params[:group_id], params[:user_id])
    GroupsUsers.update_all({:is_admin => true}, {:group_id => group_user.group_id, :user_id => group_user.user_id})
  end

  def update_group_users_count
    groups = Group.all
    groups.each do |group|
      group.update_attribute('member_count', group.users.count)
    end
  end

  def about
    render layout: 'group_about'
  end
end
