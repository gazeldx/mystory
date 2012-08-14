class ApplicationController < ActionController::Base
  helper_method :site_url, :my_site, :site, :sub_site, :mystory?, :site_name, :auto_photo, :auto_draft, :auto_link, :auto_style, :auto_img, :ignore_draft, :ignore_img, :ignore_image_tag, :ignore_style_tag, :m, :super_admin?, :manage?
  protect_from_forgery
  before_filter :redirect_mobile, :query_user_by_domain
  before_filter :url_authorize, :only => [:edit, :delete]

  def redirect_mobile
    @m = true if /android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3]) || /.*UCWEB.*/i.match(request.user_agent)
  end

  def site_url
    "http://#{request.domain}:#{request.port.to_s}"
  end
  
  def my_site
    site_url.sub(/\:\/\//, "://" + session[:domain] + ".")
  end

  def site(user)
    site_url.sub(/\:\/\//, "://" + user.domain + ".")
  end  

  def sub_site(str)
    site_url.sub(/\:\/\//, "://" + str + ".")
  end

  def mystory?
    ["mystory.cc", "mystory2.cc"].include? request.domain
  end

  def site_name
    if mystory?
      t'site.name'
    else
      t'cy.name'
    end
  end

  def authorize(item)
    unless item.user_id == session[:id]
      redirect_to site(@user)
    end
  end

  def query_user_by_domain
    if DOMAINS.include? request.domain
      if request.subdomain.match(/.+\.m/)
        @m = true
        three_domain = request.subdomain.sub(/\.m/, "")
        if three_domain == 'bbs'
          @bbs_flag = true
        else
          @user = User.find_by_domain(three_domain)
        end
      elsif request.subdomain == 'm'
        @m = true
      elsif request.subdomain == 'bbs'
        @bbs_flag = true
      else
        unless ['', 'blog'].include? request.subdomain
          @user = User.find_by_domain(request.subdomain) unless request.subdomain == 'www'
          r_to 302 if @user.nil?
        end
      end
    end
  end

  def url_authorize
    unless @user.id == session[:id]
      redirect_to site(@user)
    end
  end

  def proc_session
    session[:id] = @user.id
    session[:name] = @user.name
    session[:domain] = @user.domain
    session[:atoken], session[:asecret] = @user.atoken, @user.asecret
    session[:token], session[:openid] = @user.token, @user.openid
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
      tmp + t('etc') + "<a href='#{si}' target='_blank'>" + t('whole_article') + comments + "</a>"
    else
      tmp + "<a href='#{si}' target='_blank'>" + comments + "</a>"
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
        album = photo.album
        user = album.user
        source_from = " [<a href='#{m_or(site(user) + album_path(album))}' target='_blank'>#{album.name}</a>]"
        if @user.nil? or user.id!=@user.id
          source_from = "#{t('source_from')}<a href='#{m_or(site(user))}' target='_blank'>#{user.name}</a>#{t('his_album')}" + source_from
        else
          source_from = "#{t('source_from')}#{t('_album')}" + source_from
        end
        g = "<div style='text-align:center'><img src='#{@m ? photo.avatar.thumb.url : photo.avatar.url}' alt='#{photo.description}'/><br/><span class='pl'>#{source_from} #{ta} #{photo.description}</span></div>"
        mystr = mystr.sub(e[0], g)
      end
    end
    mystr
  end

  def text_it_pure(something)
    s = ignore_draft(something.gsub(/\r\n/,' '))
    s = ignore_img(s)
    s = ignore_image_tag(s)
    ignore_style_tag(s)
  end

  def ignore_draft(mystr)
    m = mystr.scan(/(##(.*?)##)/m)
    m.each do |e|
      mystr = mystr.sub(e[0], " ")
    end
    mystr
  end

  def ignore_img(mystr)
    require 'uri'
    x = URI.extract(mystr, ['http'])
    x.each do |e|
      m = e.match(/.*.(png|jpg|jpeg|gif)/i)
      if m
        mystr = mystr.sub(m[0], "")
      end
    end
    mystr
  end

  def ignore_image_tag(str)
    m = str.scan(/\+photo\d{2,}\+/m)
    m.each do |e|
      str = str.sub(e, "")
    end
    str
  end

  def ignore_style_tag(s)
    m = s.scan(/(--([bxsrgylh]{1,3})(.*?)--)/m)
    m.each do |e|
      unless e[1].nil?
        s = s.sub(e[0], e[2])
      end
    end
    s
  end

  def r404
    render text: t('page_not_found', w: site_name), status: 404
  end

  #302 301 diffenerce see: http://stackoverflow.com/questions/3025475/what-is-the-difference-between-response-redirect-and-response-status-301-redirec
  #redirect_to default is 302
  def r_to code
    if mystory?
      redirect_to site_url, :status => code
    else
      redirect_to sub_site('blog'), :status => code
    end
  end

  def _render(str)
    if @m
      render mn(str), layout: 'm/portal'
    else
      render str
    end
  end

  def super_admin?
    ['zhangjian', 'caidingchuang'].include? session[:domain]
  end
  
  def super_admin
    unless ['zhangjian', 'caidingchuang'].include? session[:domain]
      redirect_to root_path
    end
  end

  def manage? code
    user = User.find(session[:id])
    super_admin? or user.menus.any?{|x| x.code==code}
  end

  def manager?
    user = User.find(session[:id])
    if users_path == "/#{controller_path}"
      code = ['assign_roles', 'do_assign_roles'].include?(action_name) ? 'assign_roles': 'users'
    end
    redirect_to root_path unless super_admin? or user.menus.any?{|x| x.code==code}
  end

  def weibo_auth
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(session[:atoken], session[:asecret])
    oauth
  end

  #  def verify_credentials
  ##    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  ##    request_token = oauth.consumer.get_request_token
  ##    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
  ##    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
  ##    session[:rtoken], session[:rsecret] = nil, nil
  ##    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
  ##    oauth.authorize_from_access(session[:atoken], session[:asecret])
  ##    Weibo::Base.new(oauth).verify_credentials
  #    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  #    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
  #    session[:rtoken], session[:rsecret] = nil, nil
  #    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
  #    puts session[:atoken], session[:asecret]
  ##    oauth.authorize_from_access(session[:atoken], session[:asecret])
  ##    @weibo_user = Weibo::Base.new(oauth).verify_credentials
  #  end

  def verify_credentials
    oauth = weibo_auth
    Weibo::Base.new(oauth).verify_credentials
  end

  def user_timeline(query={})
    oauth = weibo_auth
    Weibo::Base.new(oauth).user_timeline(query)
  end
  
  module Tags
    def tagsIndex
      tags = @user.tags.map {|x| x.name}
      notetags = @user.notetags.map {|x| x.name}
      a = tags + notetags
      @tags = Hash.new(0)
      a.each do |v|
        @tags[v] += 1
      end
      @tags = @tags.sort_by{|k, v| v}.reverse!
    end
  end

  module AutoCreatedUserInfo
    def same_user_info
      @user.name = t'default_real_name'
      @user.passwd = Digest::SHA1.hexdigest((10000000+Random.rand(89999999)).to_s)
      id = User.last.id + 1001
      @user.username = "u#{id}"
      @user.domain = "u#{id}"
      @user.email = "u#{id}@#{request.domain}"
      unless @user.save
        num = Random.rand(9999)
        @user.username = "u#{id}-#{num}"
        @user.domain = "u#{id}-#{num}"
        @user.email = "u#{id}-#{num}@#{request.domain}"
        @user.save
      end
    end
  end

  module Archives
    def archives_months_count
      _ns = @user.notes.where(:is_draft => false).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')")
      _bs = @user.blogs.where(:is_draft => false).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')")
      _ps = Photo.where(album_id: @user.albums).select("to_char(created_at, 'YYYYMM') as t_date, count(id) as t_count").group("to_char(created_at, 'YYYYMM')")
      a = _ns + _bs + _ps
      h = Hash.new(0)
      a.each do |x|
        h[x.t_date] += x.t_count.to_i
      end
      @items = h.sort_by{|k, v| k}.reverse!
    end
  end

  module Sina
    #    130 => 1300112204 letter is so little
    if ENV["RAILS_ENV"] == "production"
      USER_HASH_OLD = { 131 => 1447497337, 127 => 1163218074, 140 => 1338246804, 126 => 1631985261, 141 => 1407728082, 142 => 1245732825, 143 => 1870913595, 144 => 1410248531, 145 => 1347189314, 146 => 1655219222 }
      USER_HASH = { 131 => 1447497337, 145 => 1347189314 }
    else
      USER_HASH_OLD = { 131 => 1447497337, 127 => 1163218074, 144 => 1410248531 }
      USER_HASH = { 131 => 1447497337, 127 => 1163218074, 144 => 1410248531 }
    end    
    #    CODE_HASH= { 127 => "MASSd53c41267bf6", 141 => "MASSb2a806bf5bfa" }
  end


  def mr
    "m/#{controller_path}/#{params[:action]}"
  end

  def mn(name)
    "m/#{controller_path}/#{name}"
  end

  def m(url)
    url.sub(/#{request.domain}/, "m.#{request.domain}")
  end

  def m_or(url)
    if @m
      m(url)
    else
      url
    end
  end

  
end
