#str = '"<h2 id="t_56470e790102dre0" class="titName SG_txta">反驳“中等收入陷阱是一个伪命题”</h2>'
#m = str.match(/.*<h2 id=.*>(.*)<\/h2>/)
#puts m[1]
#m_links = m[1].scan(/http:\/\/.*[^ html].*\.html/m)
#m_links = m[1].scan(/(http:\/\/blog.sina.com.cn\/s\/blog_(.*?)\.html)/m)
#puts m_links.inspect
#m_links.each do |e|
#  puts e[0]
#end
#i = 0
#puts i=i+1
#puts "bacd".include? "acc"
#encoding: ASCII-8BIT
str = "ggg<span class='MASSd53c41267bf6'>fsdsdfds<\/span>
fsd
sdfsfd".gsub(/<span class='MASS.*?<\/span>/m, "")
puts str