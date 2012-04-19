class ApplicationController < ActionController::Base
  helper_method :my_site, :site, :sub_site, :auto_photo, :auto_draft, :auto_link, :auto_style, :auto_img
  protect_from_forgery
  before_filter :query_user_by_domain
  before_filter :url_authorize, :only => [:edit, :delete]

  def my_site
    SITE_URL.sub(/\:\/\//, "://" + session[:domain] + ".")
  end

  def site(user)
    SITE_URL.sub(/\:\/\//, "://" + user.domain + ".")
  end

  def sub_site(str)
    SITE_URL.sub(/\:\/\//, "://" + str + ".")
  end

  def authorize(item)
    unless item.user_id == session[:id]
      redirect_to site(@user)
    end
  end

  def query_user_by_domain
    if request.domain==DOMAIN_NAME
      if request.subdomain == 'bbs'
        @bbs_flag = true
      else
        @user = User.find_by_domain(request.subdomain)
      end
    end
  end

  def url_authorize
    unless @user.id == session[:id]
      redirect_to site(@user)
    end
  end

  def summary_common(something, size, tmp)
    if something.is_a?(Note)
      si = note_path(something)
      count = something.notecomments.size
    elsif something.is_a?(Blog)
      si = blog_path(something)
      count = something.blogcomments.size
    end
    comments = ""
    if count > 0
      comments = ' ' + t('comments', w: count)
    end
    if something.content.size > size
      tmp + t('etc') + "<a href='#{si}'>" + t('whole_article') + comments + "</a>"
    else
      tmp + "<a href='#{si}'>" + comments + "</a>"
    end
  end

  def summary_comment_style(something, size)
    _style = style_it(something.content[0, size])
    summary_common(something, size, _style)
  end

  def style_it(something)
    s = auto_draft(something)
    s = auto_link(s)
    s = auto_img(s)
    auto_style(auto_photo(s))
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
      #Because parenthesis will be treated as url ,but no one use it.So it gsub all ().If I do not do it, this method will exception:unmatched close parenthesis
      m = mystr.match(/([ \n][^ \n]*)#{e.gsub(/[()]/, '')}/)
      e_pic = e.match(/.*.(png|jpg|jpeg|gif)/i)
      unless m.nil? or e_pic
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

  def auto_img(mystr)
    require 'uri'
    x = URI.extract(mystr, ['http'])
    x.each do |e|
      m = e.match(/.*.(png|jpg|jpeg|gif)/i)
      if m
        g = "<div style='text-align:center'><img src='#{m}'/></div>"
        mystr = mystr.sub(m[0], g)
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
      unless photo.nil?
        ta = ""
        unless photo.description.nil?
          ta = ":"
        end
        source_from = " [<a href='#{site(photo.album.user)+ album_path(photo.album)}'>#{photo.album.name}</a>]"
        if @user.nil? or photo.album.user_id!=@user.id
          source_from = "#{t('source_from')}<a href='#{site(photo.album.user)}'>#{photo.album.user.name}</a>#{t('his_album')}" + source_from
        else
          source_from = "#{t('source_from')}#{t('_album')}" + source_from
        end
        g = "<div style='text-align:center'><img src='#{photo.avatar.url}' alt='#{photo.description}'/><br/><span class='pl'>#{source_from} #{ta} #{photo.description}</span></div>"
        mystr = mystr.sub(e[0], g)
      end
    end
    mystr
  end

end
