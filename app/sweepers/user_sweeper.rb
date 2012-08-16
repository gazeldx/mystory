class UserSweeper < ActionController::Caching::Sweeper
  observe User

  def after_create(user)
    expire_cache_for(user)
  end

  def after_update(user)
    expire_action(:controller => 'blogs', :action => 'index')
  end

  def after_destroy(user)
    expire_cache_for(user)
  end

  private
  def expire_cache_for(user)
#    expire_page(:controller => 'users', :action => 'index')
    
#    expire_fragment('recent_users')
  end
end