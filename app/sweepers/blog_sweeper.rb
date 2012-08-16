class BlogSweeper < ActionController::Caching::Sweeper
  observe Blog

  def after_create(blog)
    expire_cache_for(blog)
  end

  def after_update(blog)
    expire_cache_for(blog)
  end

  def after_destroy(blog)
    expire_cache_for(blog)
  end

  private
  def expire_cache_for(blog)
#    expire_page(:controller => 'blogs', :action => 'index')

#    expire_fragment('recent_blogs')
  end
end