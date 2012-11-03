class GadsController < ApplicationController
  layout 'help'
  skip_before_filter :url_authorize
  before_filter :group_admin  

  def index
    @gads = @group.gads.order('created_at')
  end

  def new
    @gad = Gad.new(:stype => params[:stype])
  end

  def edit
    @gad = Gad.find(params[:id])
  end

  def create
    @gad = Gad.new(params[:gad])
    @gad.group = @group
    flash[:notice] = t'create_succ' if @gad.save!
    redirect_to gads_path
  end

  def update
    @gad = Gad.find(params[:id])
    if @gad.update_attributes(params[:gad])
      redirect_to gads_path, :notice => t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @gad = Gad.find(params[:id])
    @gad.destroy
    redirect_to gads_path, :notice => t('delete_succ')
  end
  
end