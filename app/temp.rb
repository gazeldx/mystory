# To change this template, choose Tools | Templates
# and open the template in the editor.


str = "<html>f<br/>dddf</span>fffd<fdd<span>>dd"
puts b = str.gsub(/<br\/>/, "\r\n").gsub(/<span>/, " ").gsub(/<\/span>/, " ")
