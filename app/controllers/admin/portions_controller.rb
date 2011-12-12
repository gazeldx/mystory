class Admin::PortionsController < Admin::BaseController
  def create
    @portion = Portion.new(params[:portion])
    @portion.user_id=session[:user_id]
    if @portion.save
      redirect_to admin_poem_path,notice: t('create_succ')
    else
      render :edit
    end
  end

  def edit
    #Why where is not OK?Maybe where is for list each
    #@portion = Portion.where(["user_id = ?", session[:user_id]])
    @portion = Portion.find_by_user_id(session[:user_id])
    @portion = Portion.new if @portion.nil?
  end

  def update
    @portion = Portion.find_by_user_id(session[:user_id])
    if @portion.update_attributes(params[:portion])
      redirect_to admin_poem_path, notice: t('update_succ')
    else
      render :edit
    end
  end
end
