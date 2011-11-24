class Admin::AdminController < Admin::ApplicationController

  def index
    @news = News.order("updated_at DESC").limit(6)
    #TODO notice that order by update_at,so they can do which show in index
  end
end
