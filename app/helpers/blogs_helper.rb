module BlogsHelper
  def post_info(blog)
    info = blog.created_at.strftime t('time_format')  + ' in '
    info += link_to blog.category.name, blog.category, :title => t('view_blogs_in_category')
    raw info
  end
end