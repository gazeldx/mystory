class AssortmentsController < ApplicationController
  layout 'help'
  def index
    @assortments = Assortment.where(["user_id = ?", session[:id]]).order('created_at')
    @assortment = Assortment.new
  end

  def edit
    @assortment = Assortment.find(params[:id])
  end

  def create
    @assortment = Assortment.new(params[:assortment])
    @assortment.user_id=session[:id]
    if @assortment.save
      flash[:notice] = t('create_succ', :w => t('_assortment'))
    else
      flash[:error] = t'taken', :w => @assortment.name
    end
    redirect_to assortments_path
  end

  def update
    @assortment = Assortment.find(params[:id])
    if @assortment.update_attributes(params[:assortment])
      redirect_to edit_assortment_path, :notice => t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @assortment = Assortment.find(params[:id])
    if @assortment.rblogs.exists?
      flash[:error] = t'assortment.has_when_delete'
    else
      @assortment.destroy
      flash[:notice] = t'delete_succ'
    end
    redirect_to assortments_path
  end

  def up
    @assortment = Assortment.find(params[:id])
    @assortment_t = Assortment.where(["user_id = ? AND created_at < ?", session[:id],@assortment.created_at]).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @assortment = Assortment.find(params[:id])
    @assortment_t = Assortment.where(["user_id = ? AND created_at > ?", session[:id],@assortment.created_at]).order('created_at').first
    exchange_create_at
  end  

  private
  def exchange_create_at
    m_c_at = @assortment.created_at
    @assortment.update_attribute('created_at', @assortment_t.created_at)
    @assortment_t.update_attribute('created_at', m_c_at)
    redirect_to assortments_path
  end  
end
