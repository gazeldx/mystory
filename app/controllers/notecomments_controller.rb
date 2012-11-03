class NotecommentsController < ApplicationController
  include Recommend, Comment

  def create
    @note = Note.find(params[:note_id])
    comments = @note.notecomments
    if params[:reply_user_id].to_s != '' and @note.user_id == session[:id]
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:notecomment][:body]
#      Notecomment.update_all({:body => body}, {:id => comment.id})
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'

      reply_user = User.find(params[:reply_user_id])
      reply_user.update_attribute('unread_comments_count', reply_user.unread_comments_count + 1)
    else
      if comments.collect{|c| c.user_id}.include?(session[:id])
        comment = comments.find_by_user_id(session[:id])
        body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' '
        if params[:reply_user_id].to_s != ''
          body = body + "repU#{params[:reply_user_id]} " + params[:notecomment][:body]
          flash[:notice] = t'reply_succ'
        else
          body += params[:notecomment][:body]
          flash[:notice] = t'add_comment_succ'
        end
        comment.update_attribute('body', body)
      else
        @notecomment = comments.new(params[:notecomment])
        @notecomment.user_id = session[:id]
        if params[:reply_user_id].to_s != ''
          @notecomment.body = "repU#{params[:reply_user_id]} " + @notecomment.body
        end
        @notecomment.save
        Note.update_all({:comments_count => @note.comments_count + 1, :replied_at => Time.now}, {:id => @note.id})
        flash[:notice] = t'comment_succ'
        expire_fragment("portal_body")
        expire_fragment("portal_hotest")
      end
      writer = @note.user
      writer.update_attribute('unread_commented_count', writer.unread_commented_count + 1) if writer.id != session[:id]
    end
    if params[:comment_and_recommend]
      _r = Rnote.find_by_user_id_and_note_id(session[:id], @note.id)
      save_rnote(@note, params[:notecomment][:body]) if _r.nil?
      flash[:notice] = flash[:notice] + t('article_recommended')
    end
    redirect_to note_path(@note) + "#notice"
  end

  def m_reply
    @comment = Notecomment.find(params[:comment_id])
    render 'm/shared/m_reply', :layout => 'm/portal'
  end

  def do_m_notecomments_reply
    comment = Notecomment.find(params[:notecomment][:id])
    body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:body]
    comment.update_attribute('body', body)
    flash[:notice] = t'reply_succ'

    user = comment.user
    user.update_attribute('unread_comments_count', user.unread_comments_count + 1)
    render 'm/shared/notice', :layout => 'm/portal'
  end

  def destroy
    @note = Note.find(params[:note_id])
    @comment = @note.notecomments.find(params[:id])
    @comment.destroy
    Note.update_all("comments_count = #{@note.comments_count - 1}", "id = #{@note.id}")
    flash[:notice] = t('delete_succ1', :w => t('comment'))
    redirect_to note_path(@note) + "#notice"
  end

  def like
    comment = Notecomment.find(params[:id])
    like_it comment
    render json: comment.as_json
  end
  
end
