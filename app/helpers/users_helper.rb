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

  #TODO Question: why · will error?Why ""+link_to(t('all'), url) is different from link_to(t('all', url))+""?
#  def all_link(url)
#     "&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·"+
#    content_tag(:span, ""+link_to(t('all'), url) , :class => 'pl')
#  end
  def blank_dot
    raw t('_dot')
  end
  
  def show_note(note)
    if note.content.size > 180
      note.content[0,150].gsub(/\r\n/,'&nbsp;') + (link_to ' >>>', note)
    else
      note.content.gsub(/\r\n/,'&nbsp;')
    end
  end

  def summary_with_etc(someting, size)
    if someting.size > size
      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
      raw someting[0,size-30].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "") + t('chinese_etc')
    else
      raw someting.gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    end
  end

#  def show_blog(blog)
#    if blog.content.size > 260
#      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
#      blog.content[0,200].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "") + t('chinese_etc')
#    else
#      blog.content.gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
#    end
#  end

  def summary(someting, size)
    if someting.size > size
      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
      raw someting[0,size-30].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "") + t('chinese_etc')
    else
      raw someting.gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    end
  end
end
