module GroupsHelper
  def group_pic_not_use group
    content_tag(:a, image_tag(group.avatar.thumb.url, width: USER_THUMB_SIZE, height: USER_THUMB_SIZE), href: site(group), title: "#{group.maxim}")
  end

  def college? name
    name.match(/.*(#{t'university'}|#{t'_college'}).*/)
  end

  def show_schools
    s = ""
    @school_groups.each do |group|
      if group.member_count >= MIN_COLLEGE_MEMBER
         s += link_to group.name, site(group), target: '_blank'
      else
         s += group.name
      end
      s += "&nbsp;&nbsp;&nbsp;"
    end
    raw s
  end

  def set_as_good_article item
    if group_admin? @group
      if item.is_a? Note
        url = assign_gcolumns_note_path(item)
      else
        url = assign_gcolumns_blog_path(item)
      end      
      if controller.controller_name == 'gcolumns'
        link_name = t('good_article_manage')
      else
        link_name = t('set_as_good_article')
      end
      span_c = raw " #{link_to link_name, url, target: '_blank', style: 'color: red; !important'}"
      content_tag(:span, span_c)
    end
  end

  def group_good_articles
    (@group.notes.limit(3) | @group.blogs.limit(4)).sort_by{|x| x.created_at}.reverse!
  end
end
