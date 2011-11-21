class HomeController < ApplicationController
  #before_filter :audit
  
  def index
    puts "index in now _____________________________________________"
    @news = News.order("updated_at DESC").limit(6)

    #TODO notice that order by update_at,so they can do which show in index
    respond_to do |format|
      format.html
    end
  end

  private
  def audit
    
    redirect_to "/gazeldx"
    #abc.def.xxx.com
    puts request.url#http://abc.def.xxx.com
#    if request.domain=="localhost"
#      respond_to do |format|
#        format.html { redirect_to "/gazeldx" }
#      end
#    end
    puts request.domain#xxx.com
    #puts request.subdomain[0]#abc
    #puts request.subdomain[1]#def
    puts request.user_agent#Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.202 Safari/535.1
  end
end