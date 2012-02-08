class Admin::HomeController < Admin::BaseController

#  layout 'portal_others'

  def index
    
  end

  def logout
    session[:id] = nil
    session[:name] = nil
    redirect_to root_path
  end
end