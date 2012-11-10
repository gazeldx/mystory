class MemoircommentsController < ApplicationController
  include Recommend, Comment

  def create
    @memoir = @user.memoir
    comments = @memoir.memoircomments
    if params[:reply_user_id] != '' and @memoir.user_id == session[:id]
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:memoircomment][:body]
#      Memoircomment.update_all({:body => body}, {:id => comment.id})
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'

      reply_user = User.find(params[:reply_user_id])
      reply_user.update_attribute('unread_comments_count', reply_user.unread_comments_count + 1)
    else
      if comments.collect{|c| c.user_id}.include?(session[:id])
        comment = comments.find_by_user_id(session[:id])
        body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' '
        if params[:reply_user_id].to_s != ''
          body = body + "repU#{params[:reply_user_id]} " + params[:memoircomment][:body]
          flash[:notice] = t'reply_succ'
        else
          body += params[:memoircomment][:body]
          flash[:notice] = t'add_comment_succ'
        end
        comment.update_attribute('body', body)
      else
        @memoircomment = comments.new(params[:memoircomment])
        @memoircomment.user_id = session[:id]
        if params[:reply_user_id].to_s != ''
          @memoircomment.body = "repU#{params[:reply_user_id]} " + @memoircomment.body
        end
        @memoircomment.save
        Memoir.update_all({:comments_count => @memoir.comments_count + 1}, {:id => @memoir.id})
        flash[:notice] = t'comment_succ'
      end
      writer = @memoir.user
      writer.update_attribute('unread_commented_count', writer.unread_commented_count + 1) if writer.id != session[:id]
    end
    if params[:comment_and_recommend]
      _r = Rmemoir.find_by_user_id_and_memoir_id(session[:id], @memoir.id)
      save_rmemoir(@memoir, params[:memoircomment][:body]) if _r.nil?
      flash[:notice] = flash[:notice] + t('memoir_recommended')
    end
    redirect_to autobiography_path + "#notice"
  end

  def destroy
    @memoir = @user.memoir
    @comment = @memoir.memoircomments.find(params[:id])
    @comment.destroy
    Memoir.update_all({:comments_count => @memoir.comments_count - 1}, {:id => @memoir.id})
    flash[:notice] = t('delete_succ1', :w => t('comment'))
    redirect_to autobiography_path + "#notice"
  end

  def like
    comment = Memoircomment.find(params[:id])
    like_it comment
    render json: comment.as_json
  end
end
