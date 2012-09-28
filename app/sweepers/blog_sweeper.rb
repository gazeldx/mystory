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
    expire_fragment("portal_body")
    expire_fragment("portal_hotest")
    expire_fragment("portal_latest")
    expire_fragment("side_archives_#{blog.user.id}")
    expire_fragment("side_blog_latest_#{blog.user.id}")    
  end
end