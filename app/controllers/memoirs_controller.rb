class MemoirsController < ApplicationController
  layout 'new'

  def portal
#    @memoirs = Memoirs.all.order('updated_at DESC')
    render :layout => 'portal'
  end

  def index
    @memoir = Memoir.find_by_user_id(@user.id)
    unless @memoir.nil?
      add_view_count
      #TODO refactor
      @all_comments = @memoir.memoircomments.order('likecount DESC, created_at')
      @comments_uids = @all_comments.collect{|c| c.user_id}
    end
    render :layout => 'memoir_share'
  end
  
  def create
    @memoir = Memoir.new(params[:memoir])
    @memoir.user_id = session[:id]
    if @memoir.save
      redirect_to edit_memoirs_path, :notice => t('create_succ')
    else
      render :edit
    end
  end

  def edit
    @memoir = Memoir.find_by_user_id(session[:id])
    @memoir = Memoir.new if @memoir.nil?
  end

  def update
    @memoir = Memoir.find_by_user_id(session[:id])
    if @memoir.update_attributes(params[:memoir])
      flash[:notice2] = t'update_succ'
      redirect_to autobiography_path
    else
      render :edit
    end
  end

  private
  def add_view_count
    @memoir.views_count += 1
    Memoir.update_all("views_count = #{@memoir.views_count}", "id = #{@memoir.id}")
  end
end
