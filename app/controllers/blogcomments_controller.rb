class BlogcommentsController < ApplicationController

  def create
    @blog = Blog.find(params[:blog_id])
    comments = @blog.blogcomments
    if params[:reply_user_id] != ''
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:blogcomment][:body]
      comment.update_attribute('body', body)
      #TODO CAN'T KEEP updated_at.keep it will make comment show well
      #comment.update_attributes(:body => body, :updated_at => comment.updated_at)
      flash[:notice] = t'reply_succ'
    elsif comments.collect{|c| c.user_id}.include?(session[:id])
      comment = comments.find_by_user_id(session[:id])
      body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' ' + params[:blogcomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'add_comment_succ'
    else
      @blogcomment = comments.new(params[:blogcomment])
      @blogcomment.user_id = session[:id]
      @blogcomment.save
      @blog.update_attribute('comments_count', @blog.comments_count + 1)
      flash[:notice] = t'comment_succ'
    end
    redirect_to blog_path(@blog) + "#notice"
  end

  def destroy
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.blogcomments.find(params[:id])
    @comment.destroy
    @blog.update_attribute('comments_count', @blog.comments_count - 1)
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to blog_path(@blog) + "#notice"
  end

end
