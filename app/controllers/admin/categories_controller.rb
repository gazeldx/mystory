class Admin::CategoriesController < Admin::BaseController
  #Use "respond_to :html, :js" with create.js.erb will be work with respond_with.
  #The form_for must use ,:remote=>true.
  #Then all of the render will be as JS.
  #So redirect_to now will useless.
  #See more at http://lee2013.iteye.com/blog/1018349
  #respond_to :html, :js
  
  def index
    @categories = Category.where(["user_id = ?", session[:user_id]]).order('created_at')
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])
    @category.user_id=session['user_id']
    if @category.save
      flash[:notice]=t('create_succ',w: t('_category'))
    else
      flash[:error]=t('taken',w: @category.name)
#      respond_with @category
    end
    redirect_to admin_categories_path
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to edit_admin_category_path, notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    #I think exists? is better than any? because exists? is SELECT 1 FROM "news" WHERE "news"."category_id" = 2 LIMIT 1
    # and any? is SELECT COUNT(*) FROM "news" WHERE "news"."category_id" = 2
    if @category.news.exists?
      flash[:error]=t('used')
    else
      @category.destroy
      flash[:notice]=t('delete_succ')
    end
    redirect_to admin_categories_path
  end

  def show
    @category = Category.find(params[:id])
  end

  def up
    @category = Category.find(params[:id])
    @category_t=Category.where(["user_id = ? AND created_at < ?", session[:user_id],@category.created_at]).order('created_at DESC').first
    exchange_create_at
  end

  def down
    @category = Category.find(params[:id])
    @category_t=Category.where(["user_id = ? AND created_at > ?", session[:user_id],@category.created_at]).order('created_at').first
    exchange_create_at
  end

  private
  def exchange_create_at
    m_c_at=@category.created_at
    @category.update_attribute('created_at',@category_t.created_at)
    @category_t.update_attribute('created_at',m_c_at)
    redirect_to admin_categories_path
  end
end
