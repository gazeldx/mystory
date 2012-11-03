class BlogcommentsController < ApplicationController
  include Recommend, Comment

  def create
    @blog = Blog.find(params[:blog_id])
    comments = @blog.blogcomments
    if params[:reply_user_id].to_s != '' and @blog.user_id == session[:id]
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:blogcomment][:body]
#      Blogcomment.update_all({:body => body}, {:id => comment.id})
      comment.update_attribute('body', body)
      #      Blogcomment.update(comment.id, :body => body)
      #Blogcomment.update will auto update updated_at,But update_all will not.
      flash[:notice] = t'reply_succ'
      
      reply_user = User.find(params[:reply_user_id])
      reply_user.update_attribute('unread_comments_count', reply_user.unread_comments_count + 1)
    else
      if comments.collect{|c| c.user_id}.include?(session[:id])
        comment = comments.find_by_user_id(session[:id])
        body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' '
        if params[:reply_user_id].to_s != ''
          body = body + "repU#{params[:reply_user_id]} " + params[:blogcomment][:body]
          flash[:notice] = t'reply_succ'
        else
          body += params[:blogcomment][:body]
          flash[:notice] = t'add_comment_succ'
        end
        comment.update_attribute('body', body)
      else
        @blogcomment = comments.new(params[:blogcomment])
        @blogcomment.user_id = session[:id]
        if params[:reply_user_id].to_s != ''
          @blogcomment.body = "repU#{params[:reply_user_id]} " + @blogcomment.body
        end
        @blogcomment.save
        Blog.update_all({:comments_count => @blog.comments_count + 1, :replied_at => Time.now}, {:id => @blog.id})
        #        Blog.update(@blog.id, :comments_count => @blog.comments_count + 1, :replied_at => Time.now)
        #        Blog.update_all(["replied_at = ?", Time.now], "id = #{@blog.id}")
        flash[:notice] = t'comment_succ'
        expire_fragment("portal_body")
        expire_fragment("portal_hotest")
      end
      writer = @blog.user
      writer.update_attribute('unread_commented_count', writer.unread_commented_count + 1) if writer.id != session[:id]
    end
    if params[:comment_and_recommend]
      _r = Rblog.find_by_user_id_and_blog_id(session[:id], @blog.id)
      save_rblog(@blog, params[:blogcomment][:body]) if _r.nil?
      flash[:notice] = flash[:notice] + t('article_recommended')
    end
    redirect_to blog_path(@blog) + "#notice"
  end

  def m_reply
    @comment = Blogcomment.find(params[:comment_id])
    render 'm/shared/m_reply', :layout => 'm/portal'
  end

  def do_m_blogcomments_reply
    comment = Blogcomment.find(params[:blogcomment][:id])
    body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:body]
    comment.update_attribute('body', body)
    flash[:notice] = t'reply_succ'

    user = comment.user
    user.update_attribute('unread_comments_count', user.unread_comments_count + 1)
    render 'm/shared/notice', :layout => 'm/portal'
  end

  #A little bug: not update unread_comments_count.It is hard to do so.
  def destroy
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.blogcomments.find(params[:id])
    @comment.destroy
    Blog.update_all("comments_count = #{@blog.comments_count - 1}", "id = #{@blog.id}")
    flash[:notice] = t('delete_succ1', :w => t('comment'))
    redirect_to blog_path(@blog) + "#notice"
  end

  def like
    comment = Blogcomment.find(params[:id])
    like_it comment
    render :json => comment.as_json
  end

end
