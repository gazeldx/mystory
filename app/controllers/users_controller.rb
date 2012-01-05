class UsersController < ApplicationController
  layout 'portal_others'
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(session[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: t('update_succ')
    else
      render action: "edit"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.avatar = params[:file]
    #TODO change file name
    #@user.avatar = File.open('somewhere')
    #@user.avatar_identifier = @user.avatar_identifier.sub!(/.*\./, "me.")
    if @user.save
      flash[:notice]=t'regiter_succ_memo'
      session[:id] = @user.id
      session[:name] = @user.name
      session[:domain] = @user.domain
#      redirect_to "http://" + @user.domain + "." + DOMAIN_NAME + ":3000/like"
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
end
