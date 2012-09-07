puts "最近的一些'事件，让我对\"名人们有了些新认识。事情还是".gsub(/['"]/," ")

#str = '好人不一定有好结局，聪明repLyFromM4446413120 人会有好结局。repLyFromM1346413120 好的结ReplyFRo3mU局需要自己创造。。。。'
##m = str.match(/(repLyFromM(\d{10}) (?!^\d).*)?$/m)
##puts m.inspect
#m = str.split(/repLyFromM/m)
#puts m.inspect
#puts m.size
#m.each_with_index do |e, i|
#  if i == (m.size - 1)
#    puts e.inspect
#    unless e.match(/.*ReplyFRomU.*$/m)
#      time = Time.at(e.match(/(\d{10}).*$/)[1].to_i)
#      puts time
#    end
#  end
#end
#time


#m = str.match(/.*(repLyFromM(\d{10}) [^(\d{10})]*)$/m)
#m = str.match(/.*@mystory\.cc/)
#puts m.inspect
#m_links = m[1].scan(/http:\/\/.*[^ html].*\.html/m)
#m_links = m[1].scan(/(http:\/\/blog.sina.com.cn\/s\/blog_(.*?)\.html)/m)
#puts m_links.inspect
#m_links.each do |e|
#  puts e[0]
#end
#i = 0
#puts i=i+1
#puts "bacd".include? "cb"
#
#str = "
 #".gsub(/^[ \n]{1,150}/m, " ").gsub(/[ \r\n]{1,150}$/m, "")
#puts str
#h = {"peter" => ["apple", "orange", "mango"], "sandra" => ["flowers", "bike"]}
#puts h.map { |k,v| k }.inspect

#a=[2, 135, 11, 26, 3, 70, 18, 48, 22, 147, 39, 28, 44, 75, 110, 101, 131, 145]
#a.each_with_index do |x, i|
#  puts i
#end
#
#/do_m_reply_blogcomment/#{@comment.id}