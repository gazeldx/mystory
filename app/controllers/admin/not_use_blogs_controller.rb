class Admin::BlogsController < Admin::BaseController
  def index
    @blogs = Blog.where(["user_id = ?", session[:id]]).order('created_at DESC')
  end

  def new
    @blog = Blog.new
  end

  def edit
    @blog = Blog.find(params[:id])
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
        flash[:error]=t('taken',w: @category.name)
        render :new
      end
    end
  end

  def create_proc
    if @blog.save
      redirect_to admin_blogs_path,notice: t('create_succ')
    else
      render :new
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update_attributes(params[:blog])
      redirect_to edit_admin_blog_path,notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to admin_blogs_path,notice: t('delete_succ')
  end
end
