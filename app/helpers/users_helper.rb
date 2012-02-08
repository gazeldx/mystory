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

  def summary(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if tmp.size > size + 30
      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
      raw tmp[0, size] + (link_to t('chinese_etc') + ' >>', something)
    else
      raw tmp
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

  def summary_comment(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if something.is_a?(Note)
      count = something.notecomments.size
    elsif something.is_a?(Blog)
      count = something.blogcomments.size
    end
    comments = ""
    if count > 0
      comments = ' ' + t('comments', w: count)
    end
    if tmp.size > size + 30
      if count == 0
        comments = " >>"
      end
      raw tmp[0, size] + (link_to t('chinese_etc') + comments, something)
    else
      raw tmp + (link_to comments, something)
    end
  end

  def user_summary(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if tmp.size > size + 30
      raw tmp[0, size] + (link_to t('chinese_etc') + ' >>', site(something.user))
    else
      raw tmp
    end
  end

  def pic_name(something)
    a = /src="\/uploads\/image\/.*" alt="" \/>/.match(something.content)
    unless a.nil?
      a[0].sub(/src="\/uploads\/image\//,'').sub(/" alt="" \/>/,'').sub(/\//, '/thumb_')
    end
  end

#  def thumb_here(something)
#    a = /src="\/uploads\/image\/.*" alt="" \/>/.match(something.content)
##    puts something.content
##    puts "-------------------aa"
##    puts a
##    puts a.nil?
#    unless a.nil?
#      pic_name = a[0].sub(/src="\/uploads\/image\//,'').sub(/" alt="" \/>/,'')
#      puts '<img src="/uploads/thumb/'+ pic_name +'"/>'
#      raw '<img src="/uploads/image/'+ pic_name +'" height="229"/>'
#    end
#  end
end
