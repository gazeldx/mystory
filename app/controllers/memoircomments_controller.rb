class MemoircommentsController < ApplicationController

  def create
    @memoir = @user.memoir
    comments = @memoir.memoircomments
    if params[:reply_user_id] != ''
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:memoircomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'
    elsif comments.collect{|c| c.user_id}.include?(session[:id])
      comment = comments.find_by_user_id(session[:id])
      body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' ' + params[:memoircomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'add_comment_succ'
    else
      @memoircomment = comments.new(params[:memoircomment])
      @memoircomment.user_id = session[:id]
      @memoircomment.save
      flash[:notice] = t'comment_succ'
    end
    redirect_to memoirs_path + "#notice"
  end

  def destroy
    @memoir = @user.memoir
    @comment = @memoir.memoircomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to memoirs_path + "#notice"
  end
  
end
