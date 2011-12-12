class Admin::NewsController < Admin::BaseController
  def index
    @news = News.where(["user_id = ?", session[:user_id]]).order('created_at DESC')
  end

  def new
    @news = News.new
  end

  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(params[:news])
    @news.user_id=session[:user_id]
    if @news.save
      redirect_to admin_news_index_path,notice: t('create_succ')
    else
      render :new
    end
  end

  def update
    #flash[:notice] =  flash will fade away when the second redirect_to happen.
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      redirect_to edit_admin_news_path,notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy
    redirect_to admin_news_index_path,notice: t('delete_succ')
  end
end
