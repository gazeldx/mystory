class Admin::NewsController < Admin::ApplicationController
  def index
    @news = News.where(["user_id = ?", session[:user_id]]).order("created_at DESC")
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
    redirect_to admin_news_index_path,notice: t('create_succ') if @news.save
  end

  def update
    @news = News.find(params[:id])
    redirect_to :back, notice: t('update_succ') if @news.update_attributes(params[:news])
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy
    redirect_to admin_news_index_path,notice: t('delete_succ')
  end
end
