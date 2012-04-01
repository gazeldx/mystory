module BlogsHelper
  def post_info(blog)
    info = blog.created_at.strftime t('time_format')
    info += ' ' + t('posted_in') + ' ['
    info += link_to blog.category.name, blog.category, title: t('view_blogs_in_category')
    info += '] '
    if blog.created_at.strftime(t('date_format')) != blog.updated_at.strftime(t('date_format'))
      info += blog.updated_at.strftime(t('time_format')) + t('update')
    end
    raw info
  end

  def updated_tag_info(blog)
    info = ""
    if blog.created_at.strftime(t('date_format')) != blog.updated_at.strftime(t('date_format'))
      info += blog.updated_at.strftime(t('time_format')) + t('update')
    end
    info + ' ' + join_tags(blog)
  end

  def post_info2(blog)
    info = blog.created_at.strftime t('date_format')  + ' in '
    info += link_to blog.category.name, blog.category, title: t('view_blogs_in_category')
    raw info
  end

  def article_time(item)
    r = ""
    if params[:t] == 'updated' or item.is_a?(Memoir)
       r = item.updated_at.strftime t'no_year'
       r += t'update'
    else
       r = item.created_at.strftime t'no_year'
    end
    r
  end

  def join_tags(item)
    unless item.tags.blank?
#      raw '<br/>' + t('_tag_') + item.tags.map { |t| t.name }.join(", ")
      t('_tag_') + item.tags.map { |t| t.name }.join(", ")
    end
  end

  def join_notetags(item)
    unless item.notetags.blank?
      t('_tag_') + item.notetags.map { |t| t.name }.join(", ")
    end
  end
end