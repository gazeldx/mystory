class SchoolnamesController < ApplicationController
  layout 'help'
  skip_filter _process_action_callbacks.map(&:filter)
  before_filter :super_admin
  
  def index
    @schoolnames = Schoolname.includes(:group).order('group_id, created_at')
    @schoolname = Schoolname.new
  end

  def create
    group = Group.find_by_name_and_stype(params[:groupname], 1)
    #The defferences between .create! and create is excepton of create! will throw but create will not throw.So if use create here ,it will show create succ ,but reality it is not created.
    Schoolname.create!(name: params[:name], group: group)
    redirect_to schoolnames_path, :notice => t('new_succ')
  end

  def destroy    
    @schoolname = Schoolname.find(params[:id])
    @schoolname.destroy
    redirect_to schoolnames_path, :notice => t('delete_succ')
  end

end