class GroupsController < ApplicationController
  layout 'help'
  skip_before_filter :url_authorize
  before_filter :group_admin, :only => [:send_invitation, :do_send_invitation]
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
  #    render :layout => 'help'
  #  end

  def create
    @_group = Group.new(params[:group])
    if @_group.save
      flash[:notice] = t'create_succ'
      redirect_to new_group_path
    else
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
    GroupsUsers.create(group: group, user: user)
    redirect_to my_path, notice: t('operate_succ')
  end

  def do_assign_admin
    group_user = GroupsUsers.find_by_group_id_and_user_id(params[:group_id], params[:user_id])
    GroupsUsers.update_all({:is_admin => true}, {:group_id => group_user.group_id, :user_id => group_user.user_id})
    redirect_to my_path, notice: t('operate_succ')
  end

  def update_group_users_count
    groups = Group.all
    groups.each do |group|
      group.update_attribute('member_count', group.users.count)
    end
    redirect_to my_path, notice: t('refresh_succ')
  end

  def about
    render :layout => 'group_about'
  end

  def send_invitation
    @message = Message.new
  end

  def do_send_invitation
    user = User.find_by_domain(params[:domain])
    if user.nil?
      flash[:error] = t'user_not_exist'
      redirect_to send_group_invitation_path
    elsif @group.users.include? user
      flash[:error] = t'_user_in_litsoc'
      redirect_to send_group_invitation_path
    else
      @message = Message.create(:stype => MESSAGES_STYPE_GROUP_INVITATION, :body => t('_society_invitation_body', :w => @group.name, url: site(@group)), :parameters => "{\"group_id\":#{@group.id}}", :user => user)
      if @message.save
        user.update_attribute('unread_messages_count', user.unread_messages_count + 1)
        redirect_to send_group_invitation_path, :notice => t('succ', :w => t('_send'))
      else
        render :send_invitation
      end
    end
  end
  
  def accept_invitation
    group = Group.find(params[:group_id])
    GroupsUsers.create(group: group, user: @user)
    expire_fragment("head_user_groups_#{session[:id]}")
    redirect_to site(group), :notice => t('join_group_succ')
  end

end