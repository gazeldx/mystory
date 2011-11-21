class Admin::NewsController < Admin::ApplicationController
  def index
    @news = News.where(["user_id = ?", session[:user_id]])
    respond_to do |format|
      format.html
    end
  end

  def new
    @news = News.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(params[:news])
    @news.user_id=session[:user_id]

    respond_to do |format|
      if @news.save
        #TODO see is :notice or notice:?
        format.html { redirect_to :back, notice: 'News was successfully created!'}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to :back, notice: 'News was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy
    redirect_to admin_news_index_url
  end  
end
