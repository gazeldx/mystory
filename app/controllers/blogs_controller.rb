class BlogsController < ApplicationController
  layout 'memoir'
  
  def index
    @blogs = @user.blogs.page(params[:page]).order("created_at DESC")
    @categories = @user.categories.order('created_at')
  end

  def show
    @blog = Blog.find(params[:id])
    if @blog.user == @user
      @categories = @user.categories.order('created_at')
      @blog_pre = @user.blogs.where(["category_id = ? AND created_at > ?", @blog.category_id, @blog.created_at]).order('created_at').first
      @blog_next = @user.blogs.where(["category_id = ? AND created_at < ?", @blog.category_id, @blog.created_at]).order('created_at DESC').first
      comments = @blog.blogcomments
      @all_comments = (comments | @blog.rblogs.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
      @comments_uids = comments.collect{|c| c.user_id}
      ids = @user.blogs.select('id')
      @rblogs = @user.r_blogs.where(id: ids).limit(5)
      if @m
        render mr, layout: 'm/portal'
      else
        render layout: 'memoir_share'
      end
    else
      r404
    end
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
      send_blog_to_weibo
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

  private
  def send_blog_to_weibo
    if session[:atoken]
      oauth = weibo_auth
      str = "#{@blog.title} - "
      Weibo::Base.new(oauth).update("#{str}#{@blog.content[0..130-str.size]}#{site(@user) + blog_path(@blog)}")
    end
  end
end