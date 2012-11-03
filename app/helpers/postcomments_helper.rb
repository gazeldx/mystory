module PostcommentsHelper

  def p_reply_add
    link = content_tag(:a, t('add_reply'), href: 'javascript:;', onclick: "$('##{@clazz}comment_body').focus();$('#who').html('#{t'add_reply'}');$('#reply_user_id').val('')")
    raw ('&gt;' + link + '&nbsp;&nbsp;')
  end  

  def p_comment_info(body)
    s = body.scan(/repU(\d{1,}) /)
    s.each do |n|
      user = User.find(n[0])
      _replied_body = p_comment_info_title(@post.postcomments.find_by_user_id(n[0]).body)
      if _replied_body.size > 20
        etc = "..."
      end
      rbody = raw t('reply_what', u: user.name, :w => _replied_body[0..20] + etc.to_s)
      _replied_body_no_html = comment_no_html(_replied_body)
      t_rbody = content_tag(:span, rbody, title: _replied_body_no_html[0..400])
      body = body.sub(/repU#{n[0]} /, "#{t('_reply_who', :w => (user.name + t_rbody))}")
    end
    
    c_info = ""
    m = body.split(/repLyFromM/m)
    m.each_with_index do |e, i|
      if i==0
        u_c = e.split(/ReplyFRomU/m)
        u_c.each_with_index do |reply, j|
          if j==0
            c_info += reply
          else
            c_info += t('_add_reply', r: reply_info(reply))
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
              c_info += content_tag(:span, raw(t('building_who_reply', :w => @post.user.name, r: reply_info(reply))), :class => "writer_reply")
            else
              c_info += t('_add_reply', r: reply_info(reply))
            end
          end
        else
          c_info += "<br/>"
          c_info += content_tag(:span, raw(t('building_who_reply', :w => @post.user.name, r: reply_info(e))), :class => "writer_reply")
        end
      end
    end
    raw c_info
  end

  def p_comment_info_title(body)
    s = body.scan(/repU(\d{1,}) /)
    s.each do |n|
      user = User.find(n[0])
      body = body.sub(/repU#{n[0]} /, "#{t('_reply_who', :w => user.name)}")
    end

    c_info = ""
    m = body.split(/repLyFromM/m)
    m.each_with_index do |e, i|
      if i==0
        u_c = e.split(/ReplyFRomU/m)
        u_c.each_with_index do |reply, j|
          if j==0
            c_info += reply
          else
            c_info += t('_add_reply', r: reply_info(reply))
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
              c_info += content_tag(:span, raw(t('building_who_reply', :w => @post.user.name, r: reply_info(reply))), :class => "writer_reply")
            else
              c_info += t('_add_reply', r: reply_info(reply))
            end
          end
        else
          c_info += "<br/>"
          c_info += content_tag(:span, raw(t('building_who_reply', :w => @post.user.name, r: reply_info(e))), :class => "writer_reply")
        end
      end
    end
    raw c_info
  end

end