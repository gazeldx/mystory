class Admin::HomeController < Admin::BaseController
  def index
    
  end

  def logout
    session[:id] = nil
    session[:name] = nil
    redirect_to root_path
  end
end