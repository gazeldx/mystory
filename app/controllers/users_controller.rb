class UsersController < ApplicationController
  layout 'portal_others'
  #TODO :index need control key it not super_admin
  before_filter :manager?, :only => [:index, :assign_roles, :do_assign_roles]
  before_filter :url_authorize, :only => [:edit, :edit_password, :signature]
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => 100).order("created_at DESC")
    render layout: 'help'
  end

  def show
    @enjoy_books = @user.enjoys.where("stype = 1")
    @enjoy_musics = @user.enjoys.where("stype = 2")
    @enjoy_movies = @user.enjoys.where("stype = 3")
    if @m
      render mr, layout: 'm/portal'
    else
      render layout: 'memoir'
    end
  end

  def edit
    @_user = User.find(session[:id])
    @enjoy_books = @_user.enjoys.where("stype = 1").map { |t| t.name }.join(" ")
    @enjoy_musics = @_user.enjoys.where("stype = 2").map { |t| t.name }.join(" ")
    @enjoy_movies = @_user.enjoys.where("stype = 3").map { |t| t.name }.join(" ")
    if @m
      render mr, layout: 'm/portal'
    else
      render layout: 'like'
    end
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
      @_user.reload
      session[:name] = @_user.name
      session[:domain] = @_user.domain

      #TODO rubbish data may stay in enjoys table because some not used have not been deleted.
      @_user.renjoys.destroy_all
      build_enjoys @_user
      @_user.update_attributes(params[:user])
      redirect_to m_or(site_url + profile_path), notice: t('update_succ')
    else
      _render :edit
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
    render mr, layout: 'm/portal' if @m
  end

  def create
    @user = User.new(params[:user])
    @user.avatar = params[:file]
    @user.passwd = Digest::SHA1.hexdigest(params[:user][:passwd])
    if mystory?
      @user.source = 0
    else
      @user.source = 1
    end
    #TODO change file name
    #@user.avatar = File.open('somewhere')
    #@user.avatar_identifier = @user.avatar_identifier.sub!(/.*\./, "me.")
    if @user.save
      proc_session
      UserMailer.welcome_new_user(@user).deliver
      flash[:notice] = t'regiter_succ_memo'
      redirect_to m_or(my_site + edit_profile_path)
    else
      _render :new
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

  def as_a_writer
    render layout: 'help'
  end

  def signature
    @_user = User.find(session[:id])
    render layout: 'help'
  end

  def update_signature
    @_user = User.find(session[:id])
    if @_user.update_attributes(params[:user])
      flash[:notice] = t'update_succ'
      redirect_to admin_path
    else
      _render :signature
    end
  end

  def assign_roles
    @_user = User.find(params[:id])
    @roles = @_user.roles
    @all_roles = Role.order("created_at DESC")
    render layout: 'help'
  end

  def do_assign_roles
    user = User.find(params[:id])
    user.roles.destroy_all
    unless params[:role].nil?
      params[:role].each do |k|
        user.roles << Role.find(k)
      end
    end
    redirect_to users_path, notice: t('succ', w: t('assign_roles'))
  end

  def top
    if ENV["RAILS_ENV"] == "production"
      @users = User.find([2, 135, 11, 26, 3, 70, 18, 48, 22, 147, 39, 28, 44, 75, 110, 101, 131, 145])
    else
      @users = User.find([1, 2, 3, 13, 5, 6, 7, 8, 9, 12, 11])
    end

    @columns = Column.order('created_at')
    render layout: 'help'
  end

  private
  def build_enjoys(item)
    build_item(item, 'enjoy_books', 1)
    build_item(item, 'enjoy_musics', 2)
    build_item(item, 'enjoy_movies', 3)
  end

  def build_item(item, enjoy_name, stype)
    unless params[enjoy_name].to_s == ''
      _a = params[enjoy_name].split ' '
      _a.uniq.reverse.each do |x|
        enjoy = Enjoy.find_by_name_and_stype(x, stype)
        if enjoy.nil?
          enjoy = Enjoy.new
          enjoy.name = x
          enjoy.stype = stype
          enjoy.save
        end
        _renjoy = item.renjoys.build
        _renjoy.enjoy_id = enjoy.id
      end
    end
  end
end
