class MemoirsController < ApplicationController
#  layout 'user_others'
  include_kindeditor :only => [:new, :edit]
  
  def index
    @memoir =Memoir.find_by_user_id(@user.id)
  end
  
  def create
    @memoir = Memoir.new(params[:memoir])
    @memoir.user_id = session[:id]
    if @memoir.save
      redirect_to edit_memoirs_path, notice: t('create_succ')
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
      redirect_to edit_memoirs_path, notice: t('update_succ')
    else
      render :edit
    end
  end
end
