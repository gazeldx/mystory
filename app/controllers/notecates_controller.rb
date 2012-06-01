class NotecatesController < ApplicationController
  layout 'memoir'
  def index
    @notecates = Notecate.where(["user_id = ?", session[:id]]).order('created_at')
    @notecate = Notecate.new
  end

  def edit
    @notecate = Notecate.find(params[:id])
  end

  def create
    @notecate = Notecate.new(params[:notecate])
    @notecate.user_id = session[:id]
    if @notecate.save
      flash[:notice] = t('create_succ',w: t('_notecate'))
    else
      flash[:error] = t('taken',w: @notecate.name)
    end
    redirect_to notecates_path
  end

  def update
    @notecate = Notecate.find(params[:id])
    if @notecate.update_attributes(params[:notecate])
      redirect_to edit_notecate_path, notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @notecate = Notecate.find(params[:id])
    if @notecate.notes.exists?
      flash[:error] = t'notecate.has_notes_when_delete'
    else
      @notecate.destroy
      flash[:notice] = t'delete_succ'
    end
    redirect_to notecates_path
  end

  def show
    @notecate = Notecate.find(params[:id])
    if @notecate.user == @user
      @notes = @notecate.notes.page(params[:page]).order("created_at DESC")
      @notecates = @user.notecates.order('created_at')
    else
      r404
    end
  end

  def up
    @notecate = Notecate.find(params[:id])
    @category_t = Notecate.where(["user_id = ? AND created_at < ?", session[:id],@notecate.created_at]).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @notecate = Notecate.find(params[:id])
    @category_t = Notecate.where(["user_id = ? AND created_at > ?", session[:id],@notecate.created_at]).order('created_at').first
    exchange_create_at
  end  

  private
  def exchange_create_at
    m_c_at = @notecate.created_at
    @notecate.update_attribute('created_at', @category_t.created_at)
    @category_t.update_attribute('created_at', m_c_at)
    redirect_to notecates_path
  end  
end
