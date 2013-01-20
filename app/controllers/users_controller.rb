class UsersController < ApplicationController
  layout 'portal_others'
  before_filter :super_admin, :only => [:index, :assign_roles, :do_assign_roles, :destroy, :update_users_clicks_count, :edit_domain, :update_domain]
  before_filter :url_authorize, :only => [:edit, :edit_password, :signature]
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => 100).order("created_at DESC")
    render :layout => 'help'
  end

  def show
    @school_groups = @user.groups.where("stype = 1").order('groups_users.created_at')
    @enjoy_books = @user.enjoy_books
    @enjoy_musics = @user.enjoy_musics
    @enjoy_movies = @user.enjoy_movies
    if @m
      render mr, :layout => 'm/portal'
    else
      render :layout => 'memoir'
    end
  end

  def edit
    @_user = User.find(session[:id])
    if @_user.email.match(/.*@mystory\.cc/)
      render :edit_bind, :layout => 'like'
    else
      @schools = @_user.groups.where("stype = 1").select('name').order('groups_users.created_at').map { |t| t.name }.join(" ")
      @enjoy_books = @_user.renjoys.includes(:enjoy).where("enjoys.stype = 1").order('renjoys.created_at').map { |t| t.enjoy.name }.join(" ")
      @enjoy_musics = @_user.renjoys.includes(:enjoy).where("enjoys.stype = 2").order('renjoys.created_at').map { |t| t.enjoy.name }.join(" ")
      @enjoy_movies = @_user.renjoys.includes(:enjoy).where("enjoys.stype = 3").order('renjoys.created_at').map { |t| t.enjoy.name }.join(" ")
      if @m
        render mr, :layout => 'm/portal'
      else
        render :layout => 'help'
      end
    end
  end

  def edit_password
    @_user = User.find(session[:id])
    render :layout => 'like'
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
      build_school_groups(@_user, params[:user][:school])
      @_user.update_attributes(params[:user])
      expire_fragment("head_user_groups_#{session[:id]}")
      redirect_to m_or(my_site + profile_path), :notice => t('update_succ')
    else
      _render :edit
    end
  end

  def update_bind
    @_user = User.find(session[:id])
    params[:user][:passwd] = Digest::SHA1.hexdigest(params[:user][:passwd])
    if @_user.update_attributes(params[:user])
      @_user.reload
      session[:name] = @_user.name
      session[:domain] = @_user.domain
      redirect_to m_or(my_site + edit_profile_path), :notice => t('update_succ')
    else
      _render :edit_bind
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
    render mr, :layout => 'm/portal' if @m
  end

  def create
    @user = User.new(params[:user])
    @user.avatar = params[:file]
    @user.passwd = Digest::SHA1.hexdigest(params[:user][:passwd])
    #    @user.source = 0 # source is not use now.
    #TODO change file name
    #@user.avatar = File.open('somewhere')
    #@user.avatar_identifier = @user.avatar_identifier.sub!(/.*\./, "me.")
    if @user.save
      proc_session
      UserMailer.welcome_new_user(@user).deliver if Rails.env.production? and Settings[:aws]
      flash[:notice] = t'regiter_succ_memo'
      redirect_to m_or(my_site + edit_profile_path)
    else
      _render :new
    end
  end

  def destroy
    @_user = User.find(params[:id])
    @_user.destroy
    flash[:notice] = t'delete_succ'
    redirect_to users_url
  end

  def help
    render :layout => 'help'
  end

  def as_a_writer
    render :layout => 'help'
  end

  def signature
    @_user = User.find(session[:id])
    render :layout => 'help'
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
    render :layout => 'help'
  end

  def do_assign_roles
    user = User.find(params[:id])
    user.roles.destroy_all
    unless params[:role].nil?
      params[:role].each do |k|
        user.roles << Role.find(k)
      end
    end
    redirect_to users_path, :notice => t('succ', :w => t('assign_roles'))
  end

  def top
    @users = User.order('followers_num DESC').limit(50)
    render :layout => 'help'
  end

  def comments
    @users = User.order('comments_count DESC').limit(50)
    render :top, :layout => 'help'
  end

  def recommended
    if Rails.env.production?
      ids = [172, 186, 279, 180, 188, 154, 277, 254, 372, 366, 363, 374, 286, 255, 262, 171, 294, 157, 167, 44, 147, 170, 162, 4, 224, 236]
    else
      ids = [172, 186, 279, 180, 188, 154, 277, 254, 372, 366, 363, 374, 286, 255, 262, 171, 294, 157, 167, 44, 147, 170, 162, 4, 224, 236]
    end
    r = User.find(ids)
    @users = ids.map{|id| r.detect{|e| e.id == id}}
    render :top, :layout => 'help'
  end

  #Will never been use after initialized. Can delete
#  def init_users_schools_groups
#    users = User.all
#    users.each do |user|
#      build_school_groups(user, user.school)
#    end
#  end

  def update_users_clicks_count
    users = User.all
    users.each do |user|
      notes_clicks = user.notes.sum("views_count")
      blogs_clicks = user.blogs.sum("views_count")
      photos_clicks = user.photos.sum("views_count")
      all_clicks = notes_clicks + blogs_clicks + photos_clicks
      user.update_attribute(:clicks_count, all_clicks) if all_clicks > 0
    end
    redirect_to my_path, notice: t('refresh_succ')
  end

  def edit_domain
    render :layout => 'help'
  end

  def update_domain
    user = User.find_by_domain params[:domain]
    user.update_attribute(:domain, params[:new_domain])
    redirect_to edit_domain_path, notice: 'Domain updated successfully!'
  end

  #Temp used, will never used.Can delete.
  #update_user_schools_split?id=2&schools=河海大学,新海中学,麻省理工学院
  def update_user_schools_split
    user = User.find(params[:id])
    build_school_groups(user, params[:schools])
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
      _a.uniq.each do |x|
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

  def build_school_groups(user, schools_str)
    group_ids = user.groups.where("stype = ?", GROUPS_STYPE_SCHOOL).select('id').map{|x| x.id}
    GroupsUsers.delete_all ["user_id = ? AND group_id in (?)", session[:id], group_ids]
    schools = schools_str.to_s
    unless schools == ''
      _a = schools.split /[\s,#{t('douhao')}#{t('dunhao')}]+/
      _a.uniq.each do |x|
        schoolname = Schoolname.find_by_name x
        if schoolname.nil?
          group = Group.find_by_name x
        else
          group = schoolname.group
        end
        if group.nil?
          id = Group.last.id + 1001
          group = Group.new(:name => x, :stype => GROUPS_STYPE_SCHOOL, :domain => "g#{id}")
          unless group.save
            num = Random.rand(9999)
            group.domain = "g#{id}-#{num}"
            group.save!
          end
        end
        GroupsUsers.create(group: group, user: user, :created_at => Time.now)
      end
    end
  end
  
end