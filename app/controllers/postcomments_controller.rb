class PostcommentsController < ApplicationController

  def like
    comment = Postcomment.find(params[:id])
    _reg = / #{session[:id]}/
    if _reg =~ comment.likeusers
      comment.update_attributes(:likecount => comment.likecount.to_i - 1, :likeusers => comment.likeusers.sub(_reg, ""))
    else
      comment.update_attributes(:likecount => comment.likecount.to_i + 1, :likeusers => comment.likeusers.to_s + " #{session[:id]}" )
    end
    render json: comment.as_json
  end
  
  def create
    @post = Post.find(params[:post_id])
    comments = @post.postcomments
    if params[:reply_user_id] != '' and @post.user_id == session[:id]
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:postcomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'
    elsif comments.collect{|c| c.user_id}.include?(session[:id])
      comment = comments.find_by_user_id(session[:id])
      body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' '
      if params[:reply_user_id] != ''
        body = body + "repU#{params[:reply_user_id]} " + params[:postcomment][:body]
        flash[:notice] = t'reply_succ'
      else
        body += params[:postcomment][:body]
        flash[:notice] = t'add_reply_succ'
      end
      comment.update_attribute('body', body)
    else
      @postcomment = comments.new(params[:postcomment])
      @postcomment.user_id = session[:id]
      if params[:reply_user_id] != ''
        @postcomment.body = "repU#{params[:reply_user_id]} " + @postcomment.body
      end
      @postcomment.save
      flash[:notice] = t'reply_succ'
    end
    @post.update_attribute('replied_at', Time.now)
    redirect_to post_path(@post) + "#notice"
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.postcomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to post_path(@post) + "#notice"
  end

end
