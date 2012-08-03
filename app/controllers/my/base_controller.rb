class My::BaseController < ApplicationController
  layout '/admin/layouts/application'

  protect_from_forgery
  before_filter :check_session
  
  private
  def check_session
    redirect_to "/login" if session[:id].nil?
  end
end
