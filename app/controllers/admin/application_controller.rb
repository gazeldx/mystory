#TODO question:why write as ActionController::Base the view show no head?
class Admin::ApplicationController < ActionController::Base
  layout "admin"
  protect_from_forgery
  before_filter :check_session

  private
  def check_session
    if session[:user_id].nil?
      redirect_to "/login2"
    end
  end
end
