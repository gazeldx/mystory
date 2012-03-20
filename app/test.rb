#mystr = "+photo343++photo344+"
#def scan_photos(mystr, n)
#  photos = []
#  k = 0
#  m = mystr.scan(/(\+photo(\d{2,})\+)/m)
#  m.each do |e|
#    #        photo = Photo.find_by_id(e[1])
#    #        unless photo.nil?
#    photo = e[1]
#    puts photo
#    k = k+1
#    photos << photo
#    if k == n
#      break
#    end
#    #        end
#  end
#  puts photos
#end
#puts "---"
#scan_photos(mystr,1)
#mystr = "我爱fd--k伙 d--sd与天2载-- user--fd#"
#m = mystr.scan(/(--([bxsrgylh]{1,3})(.*?)--)/m)
#puts m
#m.each do |e|
#  unless e[1].nil?
#    g = "<span style='"
#    e[1].split('').each do |v|
#      case v
#      when 'b'
#        g += "font-weight:bold;"
#      when 'x'
#        g += "font-size:1.5em;"
#      when 's'
#        g += "font-size:0.8em;"
#      when 'r'
#        g += "color:red;"
#      when 'g'
#        g += "color:green;"
#      when 'y'
#        g += "color:gold;"
#      when 'l'
#        g += "color:0000ff;"
#      when 'h'
#        g += "color:silver;"
#      end
#    end
#    g += "'>" + e[2] + "</span>"
#    mystr = mystr.sub(e[0], g)
#  end
#end
#puts mystr

#require 'uri'
#mystr = "--brs是为"
#x = URI.extract(mystr, ['http', 'https', 'ftp'])
#x.each do |e|
#  m = mystr.match(/([ \n][^ \n]*)#{e}/)
#  unless m.nil?
#    if m[1] != " "
#      g = "<a href='#{e}' target='_blank'>" + m[1] + "</a>"
#      mystr = mystr.sub(m[0], g)
#    else
#      g = "<a href='#{e}' target='_blank'>" + e + "</a>"
#      mystr = mystr.sub(e, g)
#    end
#    puts mystr
#  end
#end
#puts mystr


#mystr = "##--b 是为炒 灯 村--仙人http:google.com##"
#m = mystr.scan(/(##(.*?)##)/m)
#puts m
#m.each do |e|
#  mystr = mystr.sub(e[0], "（这儿有一段草稿）")
#end
#puts mystr

#def auto_link(mystr)
#  require 'uri'
#  x = URI.extract(mystr, ['http', 'https', 'ftp'])
#  x.each do |e|
#    m = mystr.match(/([ \n][^ \n]*)#{e}/)
#    e_pic = e.match(/.*.(png|jpg|jpeg|gif)/)
#    unless m.nil? || e_pic
#      if m[1] != " "
#        g = "<a href='#{e}' target='_blank'>" + m[1] + "</a>"
#        mystr = mystr.sub(m[0], g)
#      else
#        g = "<a href='#{e}' target='_blank'>" + e + "</a>"
#        mystr = mystr.sub(e, g)
#      end
#    end
#  end
#  mystr
#end
#
#mystr = "x fdhttp://sohu.com/xsb.jgs的fdhttp://sohu.com/x1b.jpgs的#"
#def auto_img(mystr)
#  require 'uri'
#  x = URI.extract(mystr, ['http'])
#  x.each do |e|
#    puts e
#    m = e.match(/.*.(png|jpg|jpeg|gif)/)
#    puts m
#    if m
#      puts "match"
#      g = "<br/><img src='#{m}'/>"
#      mystr = mystr.sub(m[0], g)
#    end
#  end
#  mystr
#end
#puts auto_link mystr
##puts auto_img mystr



#mystr="sd ddhttp://abc.com/defjpsgf地"
#def auto_link(mystr)
#  require 'uri'
#  x = URI.extract(mystr, ['http', 'https', 'ftp'])
#  x.each do |e|
#    puts e
##    puts e.gsub(/[()]/, '')
#
#    m = mystr.match(/([ \n][^ \n]*)#{e.gsub(/[()]/, '')}/)
#    e_pic = e.match(/.*.(png|jpg|jpeg|gif)/i)
#    unless m.nil? or e_pic
#      if m[1] != " "
#        g = "<a href='#{e}' target='_blank'>" + m[1] + "</a>"
#        mystr = mystr.sub(m[0], g)
#      else
#        g = "<a href='#{e}' target='_blank'>" + e + "</a>"
#        mystr = mystr.sub(e, g)
#      end
#    end
#  end
#  mystr
#end
#puts auto_link mystr

#mystr="dfd\)ffd"
#def auto_link(mystr)
#    m = mystr.match(/)/)
#    puts m
#end
#auto_link mystr

mystr = "-fsfsd"
m = mystr.match(/^[a-z][a-z\d\-]{2,17}[a-z\d]$/)
puts m