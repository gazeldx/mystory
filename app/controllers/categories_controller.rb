class CategoriesController < ApplicationController
  layout 'help'
  before_filter :url_authorize, :except => [:show]
  cache_sweeper :category_sweeper
  
  def index
    @categories = Category.where(["user_id = ?", session[:id]]).order('created_at')
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])
    @category.user_id = session[:id]
    if @category.save
      flash[:notice] = t('create_succ', :w => t('_category'))
    else
      flash[:error] = t'taken', :w => @category.name
    end
    redirect_to categories_path
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to edit_category_path, :notice => t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.blogs.exists?
      flash[:error] = t'category.has_blogs_when_delete'
    else
      @category.destroy
      flash[:notice] = t'delete_succ'
    end
    redirect_to categories_path
  end

  def show
    @category = Category.find(params[:id])
    if @category.user == @user
      @rids = @user.rblogs.select('blog_id').map{|x| x.blog_id}
      @categories = @user.categories.order('created_at')
      if @m
        @blogs = @category.blogs.where(:is_draft => false).page(params[:page]).order("created_at DESC")
        render mr, :layout => 'm/portal'
      else
        @blogs = @category.blogs.includes(:tags).where(:is_draft => false).page(params[:page]).order("created_at DESC")
        render :layout => 'memoir'
      end
    else
      r404
    end
  end

  def up
    @category = Category.find(params[:id])
    @category_t = Category.where(["user_id = ? AND created_at < ?", session[:id],@category.created_at]).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @category = Category.find(params[:id])
    @category_t = Category.where(["user_id = ? AND created_at > ?", session[:id],@category.created_at]).order('created_at').first
    exchange_create_at
  end  

  private
  def exchange_create_at
    m_c_at = @category.created_at
    @category.update_attribute('created_at', @category_t.created_at)
    @category_t.update_attribute('created_at', m_c_at)
    redirect_to categories_path
  end
end
