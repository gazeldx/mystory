class BlogcommentsController < ApplicationController
  
  def create
    @blog = Blog.find(params[:blog_id])
    @blogcomment = @blog.blogcomments.new(params[:blogcomment])
    @blogcomment.user_id = session[:id]
    @blogcomment.save
    flash[:notice] = t'comment_succ'
    redirect_to blog_path(@blog) + "#notice"
  end

  def destroy
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.blogcomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to blog_path(@blog) + "#notice"
  end

end
