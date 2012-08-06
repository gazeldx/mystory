module ApplicationHelper
  
  def title(_title)
    content_for :title do
      _title
    end
  end

  def metadesc(_metadesc)
    content_for :metadesc do
      _metadesc
    end
  end

  def summary(_summary)
    content_for :summary do
      _summary.gsub(/\r\n/,' ')
    end
  end

  def h(_title)
    content_for :h do
      _title
    end
  end

  def validate_form(form_id)
    raw "<script type=\"text/javascript\">$(document).ready(function(){$('##{form_id}').validate();});</script>"
  end

  def t_t(str)
    if mystory?
      t("site.#{str}")
    else
      t("cy.#{str}")
    end
  end

  def s_site_root
    if mystory?
      site_url
    else
      sub_site('blog')
    end
  end


  #month as 201204
  def chinese_month(month)
    month[0..3] + t('year') + month[4..5] + t('month')
  end

  def u_link_to(text, item)
    if item.is_a?(Note)
      path = note_path(item)
    elsif item.is_a?(Blog)
      path = blog_path(item)
    end
    link_to text, site(item.user) + path
  end

  def m_link_to(text, item)
    if item.is_a?(Note)
      path = note_path(item)
    elsif item.is_a?(Blog)
      path = blog_path(item)
    elsif item.is_a?(Category)
      path = category_path(item)
    elsif item.is_a?(Notecate)
      path = notecate_path(item)
    end
    link_to text, m(site(item.user) + path)
  end  

  def m_note_i(item)
    user = item.user
    raw "#{link_to user.name, m(site(user))}:#{m_link_to_user_note_slim item} #{m_summary_comment_portal(item, 140)} #{m_thumbs_here(item, 1)}"
  end

  def m_blog_i(item)
    user = item.user
    raw "#{link_to user.name, m(site(user))}:#{t'left_book'}#{link_to item.title, m(site(user) + blog_path(item))}#{t'right_book'} #{m_summary_comment_portal(item, 160)} #{m_thumbs_here(item, 1)}"
  end
  
  def m_memoir_i(item)
    user = item.user
    raw "#{link_to user.name, m(site(user))}:#{t'update_memoir'} #{link_to item.title, m(site(user) + memoirs_path)} #{m_summary_no_comments_portal(item, 200)} #{m_thumbs_here(item, 1)}"
  end
  
  def m_rnote_i(item)
    note = item.note
    user = note.user
    raw "#{link_to item.user.name, m(site(item.user))}:#{t'recommend_note'}&nbsp;#{item.body}<br/>&nbsp;#{t'left_square'}#{t'article_source'}#{link_to user.name, m(site(user))}:#{m_link_to_user_note note}&nbsp;#{m_summary_comment_portal(note, 140)}&#160;#{m_thumbs_here(note, 1)}#{t'right_square'}"
  end

  def m_rblog_i(item)
    blog = item.blog
    user = blog.user
    raw "#{link_to item.user.name, m(site(item.user))}:#{t'recommend_blog'}&nbsp;#{item.body}<br/>&nbsp;#{t'left_square'}#{t'article_source'}#{link_to user.name, m(site(user))}:#{t'left_book'}#{link_to blog.title, m(site(user) + blog_path(blog))}#{t'right_book'}#{m_summary_comment_portal(blog, 140)} #{m_thumbs_here(blog, 1)}#{t'right_square'}"
  end

  def m_photo_i(item)
    album = item.album
    user = album.user
    avatar = item.avatar
    i = link_to user.name, m(site(user))
    i += ":#{t'upload_photo_to'} "
    i += link_to album.name, m(site(user)+album_path(album))
    unless item.description.nil?
      i += " " + item.description
    end
    i += raw "<br/>"
    i += content_tag(:a, image_tag(avatar.mthumb.url) + t('big_pic'), href: avatar.thumb.url)
  end

  def m_rphoto_i(item)
    photo = item.photo
    album = photo.album
    user = album.user
    avatar = photo.avatar
    i = raw "#{link_to item.user.name, m(site(item.user))}:#{t'recommend_photo'}&nbsp;#{item.body}<br/>&nbsp;#{t'left_square'}#{t'article_source'}#{link_to user.name, m(site(user))}:#{t'upload_photo_to'} #{link_to album.name, m(site(user)+album_path(album))}"
    unless photo.description.nil?
      i += " " + photo.description
    end
    i += raw "<br/>#{content_tag(:a, image_tag(avatar.mthumb.url) + t('big_pic'), href: avatar.thumb.url)}#{t'right_square'}"
  end

  def m_photo_a(item)
    album = item.album
    avatar = item.avatar
    i = ""
    i = "#{item.description}<br/>" unless item.description.to_s==''
    raw i + content_tag(:a, image_tag(avatar.mthumb.url) + t('big_pic'), href: avatar.thumb.url)
  end

  def my_nav
    raw "#{link_to t('_manage'), sub_site('blog') + my_path} >&nbsp;"
  end
end
