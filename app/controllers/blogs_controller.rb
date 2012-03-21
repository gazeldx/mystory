class BlogsController < ApplicationController
  layout 'memoir'
  
  def index
    @blogs = Blog.where(["user_id = ?", @user.id]).page(params[:page]).order("created_at DESC")
    @categories = @user.categories.order('created_at')
  end

  def show
    @blog = Blog.find(params[:id])
    if @blog.user == @user
      @categories = @user.categories.order('created_at')
      @blog_pre = @user.blogs.where(["category_id = ? AND created_at > ?", @blog.category_id, @blog.created_at]).order('created_at').first
      @blog_next = @user.blogs.where(["category_id = ? AND created_at < ?", @blog.category_id, @blog.created_at]).order('created_at DESC').first
      @all_comments = (@blog.blogcomments | @blog.rblogs.select{|x| !(x.body.nil? or x.body.size == 0)}).sort_by{|x| x.created_at}
    else
      render text: t('page_not_found')
    end
  end

  def new
    @blog = Blog.new
  end

  def edit
    @blog = Blog.find(params[:id])
    authorize @blog
  end

  def create
    @blog = Blog.new(params[:blog])
    @blog.user_id = session[:id]
    if params[:category_name].nil?
      create_proc
    else
      @category = Category.new()
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
        render :new
      end
    end
  end

  def create_proc
    if @blog.save
      redirect_to blogs_path, notice: t('blog_posted')
    else
      render :new
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(params[:blog])
      flash[:notice2] = t'update_succ'
      redirect_to blog_path
    else
      render :edit
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

  def lovezhangtingting
    params[:id] = 2
    show
    render :show
  end
end