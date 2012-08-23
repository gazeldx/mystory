class NoteSweeper < ActionController::Caching::Sweeper
  observe Note

  def after_create(note)
    expire_cache_for(note)
  end

  def after_update(note)
    expire_cache_for(note)
  end

  def after_destroy(note)
    expire_cache_for(note)
  end

  private
  def expire_cache_for(note)
    expire_fragment("portal_body")
    expire_fragment("portal_hotest")
    expire_fragment("portal_latest")
    expire_fragment("side_archives_#{note.user.id}")
    expire_fragment("side_note_latest_#{note.user.id}")
  end
end