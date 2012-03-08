module UsersHelper
  def site(user)
    SITE_URL.sub(/\:\/\//, "://" + user.domain + ".")
  end
  
  def my_site
    SITE_URL.sub(/\:\/\//, "://" + session[:domain] + ".")
  end

  def whose_site(domain)
    SITE_URL.sub(/\:\/\//, "://" + domain + ".")
  end

  def myself
    User.find(session[:id])
  end

  def blank_dot
    raw t('_dot')
  end

#  def summary(something, size)
#    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
#    if tmp.size > size + 30
#      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
#      raw tmp[0, size] + (link_to t('chinese_etc') + ' >>', something)
#    else
#      raw tmp
#    end
#  end

  def summary_no_comments(something, size)
    tmp = text_it(something.content[0, size])
    m = tmp.scan(/\+photo\d{2,}\+/m)
    m.each do |e|
      tmp = tmp.sub(e, "")
    end
    if something.is_a?(Memoir)
      lint_url = memoirs_path
    else
      lint_url = something
    end
    p = tmp + t('etc') + (link_to t('whole_article') , lint_url)
    n = m.size
    if n > 1
      raw " (#{n}#{t('pic')})&nbsp;&nbsp;" + p
    else
      raw p
    end
  end

  def summary_blank(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if tmp.size > size + 30
      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
      raw tmp[0, size] + t('chinese_etc')
    else
      raw tmp
    end
  end

  #  def summary_comment(something, size)
  #    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
  #    if something.is_a?(Note)
  #      count = something.notecomments.size
  #    elsif something.is_a?(Blog)
  #      count = something.blogcomments.size
  #    end
  #    comments = ""
  #    if count > 0
  #      comments = ' ' + t('comments', w: count)
  #    end
  #    if tmp.size > size + 30
  #      if count == 0
  #        comments = " >>"
  #      end
  #      raw tmp[0, size] + (link_to t('chinese_etc') + comments, something)
  #    else
  #      raw tmp + (link_to comments, something)
  #    end
  #  end

  

  def user_summary(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if tmp.size > size + 30
      raw tmp[0, size] + (link_to t('chinese_etc') + ' >>', site(something.user))
    else
      raw tmp
    end
  end

  def pic_name(something)
    a = /<img.*? src="\/uploads\/image\/.*"/.match(something.content)
    unless a.nil?
      a[0].sub(/.*<img.*? src="\/uploads\/image\/(.*?)".*/,'\1').sub(/\//, '/thumb_')
    end
  end

  #  def thumb_here(something)
  #    p_name = pic_name(something)
  #    unless p_name.nil?
  #      if something.is_a?(Note)
  #        href = note_path(something)
  #      elsif something.is_a?(Blog)
  #        href = blog_path(something)
  #      end
  #      content_tag(:a, image_tag("/uploads/thumb/" + p_name), href: href)
  #    end
  #  end

  def photo_url(mystr)
    m = mystr.match(/\+photo(\d{2,})\+/)
    unless m.nil?
      photo = Photo.find_by_id(m[1])
      unless (photo.nil? or photo.album.user_id!=@user.id)
        photo.avatar.thumb.url
      end
    end
  end
  
  def thumb_here(something)
    p_name = photo_url(something.content)
    unless p_name.nil?
      if something.is_a?(Note)
        href = note_path(something)
      elsif something.is_a?(Blog)
        href = blog_path(something)
      end
      content_tag(:a, image_tag(p_name), href: href)
    end
  end

  def summary_comment(something, size)
    tmp = text_it(something.content[0, size])
    m = tmp.scan(/\+photo\d{2,}\+/m)
    m.each do |e|
      tmp = tmp.sub(e, "")
    end
    n = m.size
    if n > 1
      raw "(#{n}#{t('pic')})&nbsp;&nbsp;" + summary_common(something, size, tmp)
    else
      summary_common(something, size, tmp)
    end    
  end

  def summary_comment_style(something, size)
    _style = style_it(something.content[0, size])
#    _text = text_it(something.content[0, size])
#    summary_common(something, size + _style.size - _text.size, _style)
    summary_common(something, size, _style)
  end

  def summary_common(something, size, tmp)
    if something.is_a?(Note)
      count = something.notecomments.size
    elsif something.is_a?(Blog)
      count = something.blogcomments.size
    end
    comments = ""
    if count > 0
      comments = ' ' + t('comments', w: count)
    end
    if something.content.size > size
      raw tmp + t('etc') + (link_to t('whole_article') + comments, something)
    else
      raw tmp + (link_to comments, something)
    end
  end
  
  def text_it(something)
    s = auto_draft(something.gsub(/\r\n/,'&nbsp;'))
    s = auto_link(s)
    m = s.scan(/(--([bxsrgylh]{1,3})(.*?)--)/m)
    m.each do |e|
      unless e[1].nil?
        s = s.sub(e[0], e[2])
      end
    end
    raw s
  end

  def style_it(something)
    s = auto_draft(something)
    s = auto_link(s)
    raw auto_style(auto_photo(s))
  end
  
  def auto_style(mystr)
    m = mystr.scan(/(--([bxsrgylh]{1,3})(.*?)--)/m)
    m.each do |e|
      unless e[1].nil?
        g = "<span style='"
        e[1].split('').each do |v|
          case v
          when 'b'
            g += "font-weight:bold;"
          when 'x'
            g += "font-size:1.5em;"
          when 's'
            g += "font-size:0.8em;"
          when 'r'
            g += "color:red;"
          when 'g'
            g += "color:green;"
          when 'y'
            g += "color:#FF8800;"
          when 'l'
            g += "color:#0000FF;"
          when 'h'
            g += "color:#AAAAAA;"
          end
        end
        g += "'>" + e[2] + "</span>"
        mystr = mystr.sub(e[0], g)
      end
    end
    mystr
  end

  def auto_link(mystr)
    require 'uri'
    x = URI.extract(mystr, ['http', 'https', 'ftp'])
    x.each do |e|
      m = mystr.match(/([ \n][^ \n]*)#{e}/)
      unless m.nil?
        if m[1] != " "
          g = "<a href='#{e}' target='_blank'>" + m[1] + "</a>"
          mystr = mystr.sub(m[0], g)
        else
          g = "<a href='#{e}' target='_blank'>" + e + "</a>"
          mystr = mystr.sub(e, g)
        end
      end
    end
    mystr
  end

  def auto_draft(mystr)
    m = mystr.scan(/(##(.*?)##)/m)
    m.each do |e|
      mystr = mystr.sub(e[0], t('has_draft'))
    end
    mystr
  end

  def auto_photo(mystr)
    m = mystr.scan(/(\+photo(\d{2,})\+)/m)
    m.each do |e|
      photo = Photo.find_by_id(e[1])
      unless (photo.nil? or photo.album.user_id!=@user.id)
        g = "<div style='text-align:center'><img src='#{photo.avatar.url}' alt='#{photo.description}'/><br/><span class='pl'>#{photo.description}</span></div>"
        mystr = mystr.sub(e[0], g)
      end
    end
    mystr
  end

end
