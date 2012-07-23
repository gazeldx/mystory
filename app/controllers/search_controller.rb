class SearchController < ApplicationController
  layout 'help'
  
  def index
    
  end

  def blogs
    @blogs = Blog.where("title like ?", "%#{params[:title]}%").order('created_at DESC')
    puts "---------blogs are:"
    puts @blogs.inspect
  end
end