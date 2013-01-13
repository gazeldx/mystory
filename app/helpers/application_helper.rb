module ApplicationHelper
  
  def title(_title)
    content_for :title do
      _title
    end
  end

  def metadesc(_metadesc)
    content_for :metadesc do
      _metadesc.gsub(/\r\n/,' ').gsub(/['"]/," ")
    end
  end

  def summary(_summary)
    content_for :summary do
      _summary.gsub(/\r\n/,' ').gsub(/['"]/," ")
    end
  end

  def h(_title)
    content_for :h do
      _title
    end
  end

  def validate_form(form_id)
    content_for :javascript do
      javascript_include_tag "jquery.validate"
    end
    raw "<script type=\"text/javascript\">$(document).ready(function(){$('##{form_id}').validate();});</script>"
  end

  def t_t(str)
    #    if mystory?
    t("site.#{str}")
    #    else
    #      t("cy.#{str}")
    #    end
  end

  def s_site_root
    #    if mystory?
    site_url
    #    else
    #      sub_site('blog')
    #    end
  end

  def webmaster
    whose_site('webmaster')
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
    raw "#{link_to user.name, m(site(user))}:#{t'update_memoir'} #{link_to item.title, m(site(user) + autobiography_path)} #{m_summary_no_comments_portal(item, 200)} #{m_thumbs_here(item, 1)}"
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
    i += content_tag(:a, image_tag(avatar.mthumb.url) + t('big_pic'), :href => avatar.thumb.url)
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
    i += raw "<br/>#{content_tag(:a, image_tag(avatar.mthumb.url) + t('big_pic'), :href => avatar.thumb.url)}#{t'right_square'}"
  end

  def m_photo_a(item)
    avatar = item.avatar
    i = ""
    i = "#{item.description}<br/>" unless item.description.to_s==''
    raw i + content_tag(:a, image_tag(avatar.mthumb.url) + t('big_pic'), :href => avatar.thumb.url)
  end

  def my_nav
    raw "#{link_to t('_manage'), my_path} >&nbsp;"
  end

  def setting_nav
    raw "#{link_to t('_setting'), my_site + admin_path} >&nbsp;"
  end

  def group_nav
    raw "#{link_to t('manage'), society_admin_path} >&nbsp;"
  end

  def portal_body_query
    if @user.nil?
      blogs = Blog.where(:is_draft => false).includes(:user).order("replied_at DESC").limit(20)
      notes = Note.where(:is_draft => false).includes(:user).order("replied_at DESC").limit(20)
      @last_blog_id = blogs.last.id
      @last_note_id = notes.last.id
      (blogs | notes).select{|x| !(x.content.size < 40 && x.comments_count==0)}.sort_by{|x| x.replied_at}.reverse!
    else
      column_ids = @user.columns.select('id')
      blog_ids = BlogsColumns.where(:column_id => column_ids).select('blog_id')
      blogs = Blog.where(:id => blog_ids).order("id DESC").limit(20)
      note_ids = ColumnsNotes.where(:column_id => column_ids).select('note_id')
      notes = Note.where(:id => note_ids).order("id DESC").limit(20)
#      @last_blog_id = blogs.last.id unless blogs.blank?
#      @last_note_id = notes.last.id unless notes.blank?
      (blogs | notes).sort_by{|x| x.created_at}.reverse!
    end    
  end

  def portal_hotest_query
    blogs = Blog.where(:is_draft => false).includes(:user).order("comments_count DESC").limit(30)
    notes = Note.where(:is_draft => false).includes(:user).order("comments_count DESC").limit(30)
    (blogs | notes).sort_by{|x| x.comments_count}.reverse!
  end

  def portal_latest_query
    blogs = Blog.where(:is_draft => false).includes(:user).order("created_at desc").limit(50)
    notes = Note.where(:is_draft => false).includes(:user).order("created_at desc").limit(50)
    @last_blog_id = blogs.last.id
    @last_note_id = notes.last.id
    (blogs | notes).sort_by{|x| x.created_at}.reverse!
  end
  
  def portal_column_query
    @column = Column.find(params[:id])
    blogs = @column.blogs.includes(:user).order("created_at DESC").limit(35)
    notes = @column.notes.includes(:user).order("created_at DESC").limit(25)
    (blogs | notes).sort_by{|x| x.created_at}.reverse!
  end

  def portal_biographies_query
    @portal_list = Memoir.order('updated_at DESC')
  end

  def recommended_char
    content_tag(:span, " #{t('recommended_char')}", :class => 'red')
  end

  def insert_emotion
    image_tag("http://mystory.b0.upaiyun.com/images/emotions/209.gif", :onclick => 'initEmotions()', :id => 'emotions_link', :style => 'vertical-align: middle;cursor: pointer;', :title => t('insert_emotion'))
  end
  #  def all_emotions
  #    e_hash = emotions_hash
  #    r_emotions = ""
  #    e_hash.each do |id, v|
  #      r_emotions += content_tag(:li, image_tag(emotion_image_url(id), :alt => nil, :onclick => "emotionClicked('#{v}')"), :title => v)
  #    end
  #    raw r_emotions
  #  end
end
