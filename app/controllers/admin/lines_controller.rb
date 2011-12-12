class Admin::LinesController < Admin::BaseController
  def create
    @line = Line.new(params[:line])
    @line.user_id=session[:user_id]
    if @line.save
      redirect_to admin_link_path,notice: t('create_succ')
    else
      render :edit
    end
  end

  def edit
    @line = Line.find_by_user_id(session[:user_id])
    @line = Line.new if @line.nil?
  end

  def update
    @line = Line.find_by_user_id(session[:user_id])
    if @line.update_attributes(params[:line])
      redirect_to admin_link_path, notice: t('update_succ')
    else
      render :edit
    end#admin_link_path
  end
end