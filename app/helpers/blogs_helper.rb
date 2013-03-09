module BlogsHelper
  require 'xmlrpc/client'
  
  def blog_info(blog)
    info = blog.created_at.strftime t('time_format')
    info += ' ' + t('posted_in') + ' ['
    info += link_to blog.category.name, blog.category, title: t('view_blogs_in_category')
    info += '] '
    if blog.created_at.strftime(t('date_format')) != blog.updated_at.strftime(t('date_format'))
      info += blog.updated_at.strftime(t('time_format')) + t('update')
    end
    raw info
  end

  def update_info(item)
    info = ""
    if item.created_at.strftime(t('date_format')) != item.updated_at.strftime(t('date_format'))
      info += item.updated_at.strftime(t('time_format')) + t('update')
    end
    info
  end

  def show_content item
    if item.markdown?
      render('shared/markdown') + content_tag(:div, raw(item.md_content), :class => 'note_full')
    else
      content_tag(:pre, style_it(item.content), :class => 'note_full')
    end
  end

  def m_article_info(item)
    raw "#{item.created_at.strftime t('time_format')}#{t'write'}&nbsp;#{update_info item}"
  end

  def updated_tag_info(blog)
    info = ""
    if blog.created_at.strftime(t('date_format')) != blog.updated_at.strftime(t('date_format'))
      info += blog.updated_at.strftime(t('time_format')) + t('update')
    end
    info + ' ' + join_tags(blog)
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
      _tags = item.tags.map { |t|
        link_to t.name, "/tags/" + t.name
      }.join(", ")
      raw (t('_tag_') + _tags)
    end
  end

  def join_tags_blank(item)
    unless item.tags.blank?
      _tags = item.tags.map { |t|
        link_to t.name, "/tags/" + t.name, target: '_blank'
      }.join(", ")
      raw (t('_tag_') + _tags)
    end
  end

  def join_notetags(item)
    unless item.notetags.blank?
      _tags = item.notetags.map { |t|
        link_to t.name, "/tags/" + t.name
      }.join(", ")
      raw (t('_tag_') + _tags)
    end
  end

  def join_notetags_blank(item)
    unless item.notetags.blank?
      _tags = item.notetags.map { |t|
        link_to t.name, "/tags/" + t.name, target: '_blank'
      }.join(", ")
      raw (t('_tag_') + _tags)
    end
  end

  def meta_desc_blog_list
    r = t'_category_'
    @categories.each do |category|
      r += "[#{category.name}] "
    end
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_blogs'}"
    @blogs.each_with_index do |blog, i|
      break if i>11
      r += "#{t'left_book'}#{blog.title}#{t'right_book'}"
    end
    raw r
  end

  def meta_desc_note_list
    r = t'_notecate_'
    @notecates.each do |category|
      r += "[#{category.name}] "
    end
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_notes'}"
    @notes.each_with_index do |note, i|
      break if i>12
      r += "#{note.title.to_s=='' ? note.created_at.strftime(t'date_format') : note.title}#{t'dunhao'}"
    end
    raw r
  end

  def meta_desc_category_show
    r = "#{t'_category_'}[#{@category.name}]"
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_blogs'}"
    @blogs.each_with_index do |blog, i|
      break if i>12
      r += "#{t'left_book'}#{blog.title}#{t'right_book'}"
    end
    raw r
  end

  def meta_desc_notecate_show
    r = "#{t'_notecate_'}[#{@notecate.name}]"
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_notes'}"
    @notes.each_with_index do |note, i|
      break if i>13
      r += "#{note.title.to_s=='' ? note.created_at.strftime(t'date_format') : note.title}#{t'dunhao'}"
    end
    raw r
  end

  def meta_desc_albums
    r = t'_all_albums'
    @albums.each_with_index do |album, i|
      r += "[#{album.name}] "
    end
    r += " " + t('user_meta_album_c', :w => @user.name, s: site_name)
    raw r
  end

  def meta_desc_album_show
    r = "#{t('_w_album_of', a: @album.name, :w => @user.name)} "
    unless @photos.blank?
      r += t('_album_desc', n: @photos.size)
    end
    r += " #{@album.description}#{t('_metadesc_plug', :w => site_name)}"
    raw r
  end

  def meta_desc_photo
    r = t('_upload_at', :w => @photo.created_at.strftime(t'date_format'))
    r += " " + t('photo_title_desc', p: @photo.description, a: @album.name, :w => @user.name, s: site_name)
  end

  def meta_desc_user
    r = "#{@user.name} #{@user.city} #{@user.jobs} #{@user.maxim.to_s=='' ? "": "#{t'maxim'}:#{@user.maxim}"} "
    #    @user.hobbies.each_with_index do |hobby, i|
    #      r += t'_hobby_' if i==0
    #      r += "#{hobby.name} "
    #    end
    r += @user.memo.to_s=='' ? "": " #{t'_simple_desc'}#{@user.memo}"
    r += " " + t('user_meta_desc_c', :w => @user.name, s: site_name)
    raw r
  end

  def blog_read_comment_recommend item
    #    views_link = link_to t('views_count', :w => item.views_count), blog_path(item), target: '_blank' if item.views_count > 0
    views = content_tag(:span, t('views_count', :w => item.views_count), :class => 'gray')
    comments_link = "#{link_to t('comments_count', :w => item.comments_count), blog_path(item) + '#comments', target: '_blank'}&nbsp;&nbsp;" if item.comments_count > 0
    #    recommend_link = "#{link_to t('recommend_count', :w => item.recommend_count), blog_path(item) + '#recommend', target: '_blank'}&nbsp;&nbsp;" if item.recommend_count > 0
    _content = raw "#{recommend_etc item}&nbsp;#{comments_link}#{views}"
    content_tag(:span, _content, :class => 'rr')
  end

  def note_read_comment_recommend item
    #    views_link = link_to t('views_count', :w => item.views_count), note_path(item), target: '_blank' if item.views_count > 0
    views = content_tag(:span, t('views_count', :w => item.views_count), :class => 'gray')
    comments_link = "#{link_to t('comments_count', :w => item.comments_count), note_path(item) + '#comments', target: '_blank'}&nbsp;&nbsp;" if item.comments_count > 0
    _content = raw "#{recommend_etc item}&nbsp;#{comments_link}#{views}"
    content_tag(:span, _content, :class => 'rr')
  end

  def blog_read_comment_recommend_user item
    #    views_link = link_to t('views_count', :w => item.views_count), site(item.user) + blog_path(item), target: '_blank' if item.views_count > 0
    views = content_tag(:span, t('views_count', :w => item.views_count), :class => 'gray')
    comments_link = "#{link_to t('comments_count', :w => item.comments_count), site(item.user) + blog_path(item) + '#comments', target: '_blank'}&nbsp;&nbsp;" if item.comments_count > 0
    _content = raw "#{recommend_etc item}&nbsp;#{comments_link}#{views}"
    content_tag(:span, _content, :class => 'rr')
  end

  def note_read_comment_recommend_user item
    #    views_link = link_to t('views_count', :w => item.views_count), site(item.user) + note_path(item), target: '_blank' if item.views_count > 0
    views = content_tag(:span, t('views_count', :w => item.views_count), :class => 'gray')
    comments_link = "#{link_to t('comments_count', :w => item.comments_count), site(item.user) + note_path(item) + '#comments', target: '_blank'}&nbsp;&nbsp;" if item.comments_count > 0
    _content = raw "#{recommend_etc item}&nbsp;#{comments_link}#{views}"
    content_tag(:span, _content, :class => 'rr')
  end

  def read_comment_recommend_show item
    views = t('views_count', :w => item.views_count)
    comments = "#{link_to t('comments_count', :w => item.comments_count), '#comments'}&nbsp;&nbsp;" if item.comments_count > 0
    #recommend = "#{link_to t('recommend_count', :w => item.recommend_count), 'javascript:;', onclick: ''}&nbsp;&nbsp;" if item.recommend_count > 0
    _content = raw "#{editor_it item if [Note, Blog].include?(item.class)}&nbsp;&nbsp;#{recommend_etc_in item}&nbsp;&nbsp;#{comments}#{views}"
    content_tag(:span, _content, :class => 'rr')
  end

  def s_link_to item
    if item.is_a? Blog
      link_to raw(item.title[0..21]), site(item.user) + blog_path(item), target: '_blank'
    elsif item.is_a? Note
      link_to item.title.to_s=='' ? t('s_note', :w => item.created_at.strftime(t'date_format')) : raw(item.title[0..21]), site(item.user) + note_path(item), target: '_blank'
    else
      link_to raw(item.title[0..21]), site(item.user) + autobiography_path, target: '_blank'
    end
  end

  def s_link_name(name, item)
    if item.is_a? Blog
      link_to name, site(item.user) + blog_path(item), target: '_blank'
    elsif item.is_a? Note
      link_to name, site(item.user) + note_path(item), target: '_blank'
    else
      link_to name, site(item.user) + autobiography_path, target: '_blank'
    end
  end

  def s_link_to_comments(name, item)
    if item.is_a? Blog
      link_to name, "#{site(item.user) + blog_path(item)}#comments", target: '_blank'
    elsif item.is_a? Note
      link_to name, "#{site(item.user) + note_path(item)}#comments", target: '_blank'
    else
      link_to name, "#{site(item.user) + autobiography_path}#comments", target: '_blank'
    end
  end

  def s_edit_link(item)
    if item.is_a? Blog
      link_to t('edit'), edit_blog_path(item), target: '_blank'
    else
      link_to t('edit'), edit_note_path(item), target: '_blank'
    end
  end

  def s_delete_link(item)
    if item.is_a? Blog
      path = blog_path(item)
    else
      path = note_path(item)
    end
    link_to t(:delete), path, confirm:t('confirm.delete'), method: :delete
  end

  def blog_list_item_bottom blog
    str = "<br/>"
    span_c = article_time blog
    unless controller.action_name == 'show'
      span_c = raw("#{span_c}&nbsp;#{t'at'}&nbsp;[#{link_to blog.category.name, blog.category, title: t('view_blogs_in_category')}]")
    end
    span_c = raw("#{span_c}&nbsp;&nbsp;")
    unless blog.tags.blank?
      span_c += join_tags_blank blog
    end
    str += content_tag(:span, span_c, :class => 'gray')
    str += blog_read_comment_recommend blog
    raw str
  end

  def note_list_item_bottom note
    str = "<br/>"
    span_c = article_time note
    unless controller.action_name == 'show'
      span_c = raw("#{span_c}&nbsp;#{t'at'}&nbsp;[#{link_to note.notecate.name, note.notecate, title: t('view_notes_in_notecate')}]")
    end
    span_c = raw("#{span_c}&nbsp;&nbsp;")
    unless note.notetags.blank?
      span_c += join_notetags_blank note
    end
    str += content_tag(:span, span_c, :class => 'gray')
    str += note_read_comment_recommend note
    raw str
  end

  def sync_to_third_sites
    if controller.action_name == 'new'
      if weibo_active? or qq_active?
        span_c = raw "&nbsp;&nbsp;#{t'sync_to'}"
        span_c += raw "#{hidden_field_tag :sync_weibo, true}#{image_tag('/images/weibo16_16.png', width: 16, height: 16, onclick: 'switchWeiboSync()', id: 'weibo_sync', style: 'cursor: pointer;', title: t('sync_weibo_open'))}&nbsp;" if weibo_active?
        span_c += raw "#{hidden_field_tag :sync_qq, true}#{image_tag('/images/qq16_16.png', width: 16, height: 16, onclick: 'switchQqSync()', id: 'qq_sync', style: 'cursor: pointer;', title: t('sync_qq_open'))}" if qq_active?
        label_c = content_tag(:span, span_c, :class => 'gray')
        content_tag(:label, label_c, :class => 'field')
      end
    end
  end  
end