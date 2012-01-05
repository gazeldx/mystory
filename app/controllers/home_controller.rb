class HomeController < ApplicationController
  #before_filter :audit  
  def index
    #TODO here login user will see the guy he attention like douban.com .I will do it later
    if @user.nil?      
      #@portion = Portion.find_by_user_id(@user.id)
      #@line = Line.find_by_user_id(@user.id)
      @notes_new = Note.order("created_at DESC").limit(20)
      @blogs_new = Blog.order("created_at DESC").limit(20)
      @notes_hot = Note.order("created_at DESC").limit(20)
      @blogs_hot = Blog.order("created_at DESC").limit(20)
      #@categories = Category.where(["user_id = ?", @user.id])
      @users = User.order("created_at DESC").limit(20)
      render layout:'portal'
    else
      @notes = @user.notes.order("created_at DESC").limit(10)
      #      @blogs = Blog.where(["user_id = ?", @user.id]).page(params[:page]).order("created_at DESC")
      @blogs = @user.blogs.order("created_at DESC").limit(10)
      #      query_categories
      render :user
    end
  end

  #  def q_categories
  #    @categories = Category.where(["user_id = ?", @user.id]).order('created_at')
  #  end

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