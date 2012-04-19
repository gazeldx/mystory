class UsersController < ApplicationController
  layout 'portal_others'
  
  def index
    @users = User.order("created_at DESC")
  end

  def show
    render layout: 'memoir'
  end

  def edit
    @_user = User.find(session[:id])
    render layout: 'like'
  end

  def edit_password
    @_user = User.find(session[:id])
    render layout: 'like'
  end

  def update
    @_user = User.find(session[:id])
    @_user.avatar = params[:file]
    @_user.birthday = params[:date][:year]
    if @_user.update_attributes(params[:user])
      #TODO user = User.find(@_user.id) TEST IT
      @_user.reload
      session[:name] = @_user.name
      session[:domain] = @_user.domain
      redirect_to my_site + profile_path, notice: t('update_succ')
    else
      render :edit
    end
  end

  def update_password
    @_user = User.find(session[:id])
    if params[:user][:newpasswd2] != params[:user][:newpasswd]
      flash[:error] = t'password_confirm_wrong'
    elsif Digest::SHA1.hexdigest(params[:user][:passwd]) != @_user.passwd
      flash[:error] = t'old_password_wrong'
    else
      if @_user.update_attribute('passwd', Digest::SHA1.hexdigest(params[:user][:newpasswd]))
        flash[:notice] = t'update_succ'
      end
    end
    redirect_to edit_password_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.avatar = params[:file]
    @user.passwd = Digest::SHA1.hexdigest(params[:user][:passwd])
    #TODO change file name
    #@user.avatar = File.open('somewhere')
    #@user.avatar_identifier = @user.avatar_identifier.sub!(/.*\./, "me.")
    if @user.save
      flash[:notice] = t'regiter_succ_memo'
      session[:id] = @user.id
      session[:name] = @user.name
      session[:domain] = @user.domain
      redirect_to my_site + edit_profile_path
    else
      render :action=> "new"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url
  end

  def help
    render layout: 'help'
  end
end
