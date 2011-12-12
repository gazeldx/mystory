class Admin::ParamsController < Admin::BaseController
  def create
    @param = Param.new(params[:param])
    @param.user_id=session[:user_id]
    if @param.save
      redirect_to admin_options_path,notice: t('create_succ')
    else
      render :edit
    end
  end

  def edit
    @param = Param.find_by_user_id(session[:user_id])
    if @param.nil?
      @param = Param.new
      @param.teldesc=t('param.default_teldesc')
    end
  end

  def update
    @param = Param.find_by_user_id(session[:user_id])
    if @param.update_attributes(params[:param])
      redirect_to admin_options_path, notice: t('update_succ')
    else
      render :edit
    end
  end
end
