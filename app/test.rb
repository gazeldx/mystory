mystr = "+photo343++photo344+"
m = mystr.scan(/(\+photo(\d{2,})\+)/m)
puts "m="
puts m
m.each do |e|
  g = "<img src='http://zhangjian.mystory.cc:8080/albums/2/photos/51' alt='todo the desc' /> todo the desc"
  mystr = mystr.sub(e[0], g)
  puts mystr
  puts e[1]
end
puts "--"
puts mystr

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