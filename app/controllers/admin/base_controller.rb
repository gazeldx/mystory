class Admin::BaseController < ApplicationController
  layout '/admin/layouts/application'
  before_filter :url_authorize
  
  protect_from_forgery
  before_filter :check_session
  
  private
  def check_session
    redirect_to "/login" if session[:id].nil?
  end
end
