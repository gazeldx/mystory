class Admin::UsersController < Admin::BaseController
  def edit
    @_user = User.find(session[:id])
  end

  def update
    @_user = User.find(session[:id])
    @_user.avatar = params[:file]
    if @_user.update_attributes(params[:user])
      user = User.find(@_user.id)
      session[:name] = user.name
      session[:domain] = user.domain
      redirect_to admin_profile_path, notice: t('update_succ')
    else
      render :edit
    end
  end
end