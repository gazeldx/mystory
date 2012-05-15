module CommentsHelper

  def comments
    _comments = content_tag(:div, render("#{@clazz}comments/#{@clazz}comment"), id: 'comments')
    _notice = render 'shared/notice_error'
    _form = nil
    if session[:id].nil?
      _form = t'comment_login_first'
    else
      if @comments_uids.include?(session[:id])
        _span_content = t'add_comment'
      else
        _span_content = t'post_comment'
      end
      _span = content_tag(:span, _span_content, id: 'who')
      _h2 = content_tag(:h2, _span + raw(t('_comment_dot')), class: 'pic')
      _form_ = render "#{@clazz}comments/form"
      _form = _h2 + _form_
    end
    _comments + _notice + _form
  end

  def reply_info(reply)
    r = reply.match(/^(\d{10} )(.*)/)
    unless r.nil?
      reply = reply.sub(r[1], '')
      reply = reply + ' <span class=\'pl\'>' + Time.at(r[1].to_i).strftime("%Y-%m-%d") + '</span>'
    end
    raw reply
  end
  
  def comment_info(body)
    c_info = ""
    m = body.split(/repLyFromM/m)
    m.each_with_index do |e, i|
      if i==0
        u_c = e.split(/ReplyFRomU/m)
        u_c.each_with_index do |reply, j|
          if j==0
            c_info += reply
          else
            c_info += t('_add_comment', r: reply_info(reply))
          end
          if j < u_c.size-1
            c_info += "<br/>"
          end
        end
      else
        u_c = e.split(/ReplyFRomU/m)
        if u_c.size > 1
          u_c.each_with_index do |reply, j|
            c_info += "<br/>"
            if j==0
              c_info += content_tag(:span, raw(t('who_reply', w: @user.name, r: reply_info(reply))), class: "writer_reply")
            else
              c_info += t('_add_comment', r: reply_info(reply))
            end
          end
        else
          c_info += "<br/>"
          c_info += content_tag(:span, raw(t('who_reply', w: @user.name, r: reply_info(e))), class: "writer_reply")
        end
      end
    end
    raw c_info
  end

  #Difference with comment_info is user and @user
  def comment_info_user(body, user)
    c_info = ""
    m = body.split(/repLyFromM/m)
    m.each_with_index do |e, i|
      if i==0
        u_c = e.split(/ReplyFRomU/m)
        u_c.each_with_index do |reply, j|
          if j==0
            c_info += reply
          else
            c_info += t('_add_comment', r: reply_info(reply))
          end
          if j < u_c.size-1
            c_info += "<br/>"
          end
        end
      else
        u_c = e.split(/ReplyFRomU/m)
        if u_c.size > 1
          u_c.each_with_index do |reply, j|
            c_info += "<br/>"
            if j==0
              c_info += content_tag(:span, raw(t('who_reply', w: user.name, r: reply_info(reply))), class: "writer_reply")
            else
              c_info += t('_add_comment', r: reply_info(reply))
            end
          end
        else
          c_info += "<br/>"
          c_info += content_tag(:span, raw(t('who_reply', w: user.name, r: reply_info(e))), class: "writer_reply")
        end
      end
    end
    raw c_info
  end

  def c_pic(user)
    link = content_tag(:a, image_tag(user.avatar.thumb.url, alt: user.name), href: site(user))
    content_tag(:div, link, class: 'pic')
  end

  def c_author(user, comment)
    link = content_tag(:a, user.name, href: site(user))
    time = comment.created_at.strftime(t'time_format') + ' '
    content_tag(:div, raw(time + link), class: 'author')
  end

  def line_style(user, ci)
    if user.id == session[:id] and @all_comments.size > 10 and ci != @all_comments.size-1
      "background-color:#FFCCCC"
    end
  end

  def reply_add(user)
    if @user.id == session[:id]
      link = content_tag(:a, t('reply'), href: 'javascript:;', onclick: "$('##{@clazz}comment_body').focus();$('#who').html('#{t('reply_who', w:user.name)}');$('#reply_user_id').val('#{user.id}')")
    else
      link = content_tag(:a, t('add_comment'), href: 'javascript:;', onclick: "$('##{@clazz}comment_body').focus()")
    end
    raw ('&gt;' + link + '&nbsp;&nbsp;&gt;')
  end

  def comment_form(f)
    rui = hidden_field_tag(:reply_user_id)
    body = f.text_area :body, size: "64x4", class: 'comment'
    _body = content_tag(:div, body + raw('<br/>'), class: 'item')
    submit = content_tag(:span, f.submit(t('submit')), class: 'bn-flat-hot')    
    _submit = content_tag(:div, submit, class: 'item')
    rui + _body + _submit
  end

  def validate_comment_form
    raw "<script type=\"text/javascript\">$(document).ready(function(){$('#new_#{@clazz}comment').validate();});</script>"
  end
end