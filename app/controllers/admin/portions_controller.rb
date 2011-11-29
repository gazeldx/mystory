class Admin::PortionsController < ApplicationController
#  def new
#    @portion = Portion.new
#    @portion.title=t('portion.default_title')
#  end

  def create
    @portion = Portion.new(params[:portion])
    @portion.user_id=session[:user_id]
    redirect_to admin_poem_path,notice: t('create_succ') if @portion.save
  end

  def edit
    #TODO Why where is not OK?Maybe where is for list each
    #@portion = Portion.where(["user_id = ?", session[:user_id]])
    @portion = Portion.find_by_user_id(session[:user_id])
    if @portion==nil
      @portion = Portion.new
    end
  end

  def update
    @portion = Portion.find_by_user_id(session[:user_id])
    redirect_to :back, notice: t('update_succ') if @portion.update_attributes(params[:portion])
  end
end
