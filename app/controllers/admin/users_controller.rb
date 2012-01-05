class Admin::UsersController < Admin::BaseController
  def edit
    @_user = User.find(session[:id])
  end

  def update
    @_user = User.find(session[:id])
    @_user.avatar = params[:file]
    if @_user.update_attributes(params[:user])
      #TODO user = User.find(@_user.id) TEST IT
      @_user.reload
      session[:name] = @_user.name
      session[:domain] = @_user.domain
      redirect_to admin_profile_path, notice: t('update_succ')
    else
      render :edit
    end
  end
end