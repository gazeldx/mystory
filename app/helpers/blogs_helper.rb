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
end