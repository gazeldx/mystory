class Admin::HomeController < Admin::BaseController
  def index
    
  end

  def logout
    session[:user_id] = nil
    session[:user] = nil
    redirect_to root_path
  end
end