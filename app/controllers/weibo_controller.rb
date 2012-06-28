class WeiboController < ApplicationController
  Weibo::Config.api_key = "2779381811"
  Weibo::Config.api_secret = "a1e40a062b64a4402209810f65e7e70a"
  
  #  layout 'help'

  def connect
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect_to "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/weibo_callback"
  end

  def callback
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    #    @timeline = Weibo::Base.new(oauth).friends_timeline
    #     friends = Weibo::Base.new(oauth).friends
    #     user = Weibo::Base.new(oauth).user(1837900163)
    @weibo_user = Weibo::Base.new(oauth).verify_credentials
    #    @user_show = Weibo::Base.new(oauth).user_show
    #    puts @user_show.inspect
    puts @weibo_user.inspect
    if session[:id].nil?
      @user = User.find_by_weiboid(@weibo_user.id)
      if @user.nil?
        render 'login_or_new', layout: 'portal'
#        @user = User.new
#        @user.weiboid = @weibo_user.id
#        @user.name = t'default_real_name'
#        @user.passwd = Digest::SHA1.hexdigest(10000000+Random.rand(89999999))
#        @user.username = "u#{@user.id}"
#        @user.domain = "u#{@user.id}"
#        @user.email = "u#{@user.id}@mystory.cc"
#        unless @user.save
#          num = Random.rand(9999)
#          @user.username = "u#{@user.id}-#{num}"
#          @user.domain = "u#{@user.id}-#{num}"
#          @user.email = "u#{@user.id}-#{num}@mystory.cc"
#          @user.save
#        end
#        proc_session
#        flash[:notice] = t'regiter_succ_memo'
#        redirect_to my_site + edit_profile_path
      else
        proc_session
        flash[:notice] = t'weibo_login_succ'
        redirect_to my_site + like_path
      end
    else
      user = User.find_by_weiboid(@weibo_user.id)
      if user.nil?
        me = User.find(session[:id])
        me.update_attribute('weiboid', @weibo_user.id)
      else
        flash[:error] = t'weibo_bound_by_others'
      end
      redirect_to my_site + weibo_account_path
    end
  end

  def friends_timeline
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    @timeline = Weibo::Base.new(oauth).friends_timeline
  end
  
 
  def weibo_account
    @_user = User.find(session[:id])
    render layout: 'help'
  end

  def cancel_weibo_bind
    @_user = User.find(session[:id])
    @_user.update_attribute('weiboid', nil)
    redirect_to :back
  end

  def new
    if session[:id] == @user.id
      @blog = Blog.new
      render mr, layout: 'm/portal' if @m
    else
      r404
    end
  end

  def edit
    @blog = Blog.find(params[:id])
    @tags = @blog.tags.map { |t| t.name }.join(" ")
    authorize @blog
    render mr, layout: 'm/portal' if @m
  end

  def create
    @blog = Blog.create(params[:blog])
    @blog.user_id = session[:id]
    if params[:category_name].nil?
      create_proc
    else
      @category = Category.new
      @category.name = params[:category_name]
      @category.user_id = session[:id]
      if @category.save
        @blog.category_id = @category.id
        create_proc
      else
        if @category.name == ""
          flash[:error] = t'category.name_must_notnull'
        else
          flash[:error] = t('taken',w: @category.name)
        end
        _render :new
      end
    end
  end

  def create_proc
    build_tags @blog
    if @blog.save
      flash[:notice2] = t'blog_posted'
      redirect_to blog_path(@blog)
    else
      _render :new
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(params[:blog])
      @blog.tags.destroy_all
      build_tags @blog
      @blog.update_attributes(params[:blog])
      flash[:notice2] = t'update_succ'
      redirect_to blog_path
    else
      _render :edit
    end
  end

  def build_tags(item)
    unless params[:tags].to_s == ''
      tags_a = params[:tags].split ' '
      tags_a.uniq.reverse.each do |tag|
        _tag = item.tags.build
        _tag.name = tag
      end
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice: t('delete_succ')
  end

  def click_show_blog
    @blog = Blog.find(params[:id])
    @blog.content = summary_comment_style(@blog, 4000)
    render json: @blog.as_json()
  end  

  def archives
    #ISSUE to_char maybe only work in postgresql
    @items = @user.blogs.select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')").order('t_date DESC')
  end

  def month
    @blogs = @user.blogs.where("to_char(created_at, 'YYYYMM') = ?", params[:month]).page(params[:page])
    archives
  end

  def lovezhangtingting
    params[:id] = 2
    show
    render :show
  end
end