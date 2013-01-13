module PortalHelper

  def portal_show_item(item)
    user = item.user
    n = photos_count item.content
    if n > 0
      t_class = "twi twiHasPic"
    else
      t_class = "twi"
    end
    twiM = content_tag(:div, content_tag(:p, thumb_here(item), :class => 'pics'), :class => 'twiM') if n > 0

    p_avt = content_tag(:p, user_pic(user), :class => 'avt ')
    b_b = content_tag(:b, raw("#{content_tag(:b, (link_to user.name, site(user), :target => '_blank'), :class => 'nm')}#{t'maohao'}#{s_link_to item}"), :class => 'b pd')
    twiT = content_tag(:div, raw("#{p_avt}#{b_b}"), :class => 'twiT')

    ugc_c = auto_emotion(text_it_pure(item.content)[0..98])
    ugc_c += "......#{s_link_name(t('whole_article'), item)}" if item.content.size > 98
    p_ugc = content_tag(:p, raw(ugc_c), :class => 'ugc')
    b_c = ''
    cc = item.comments_count
    b_c += content_tag(:span, (s_link_to_comments t('comments_2', :w => cc), item)) if cc > 0
    b_c += "&nbsp;&nbsp;&nbsp;#{fresh_time item.created_at}"
    b_tm = content_tag(:b, raw(b_c), :class => 'tm mi')
    twiB = content_tag(:div, b_tm, :class => 'twiB')
    twiC = content_tag(:div, raw("#{p_ugc}#{twiB}"), :class => 'twiC')

    content_tag(:div, raw("#{twiM}#{twiT}#{twiC}"), :class => t_class, :id => item.id)
  end
  
  def editor_show_index
    if @user.nil?
      url = site_url
      show = t'home_page'
    else
      url = editor_path
      show = t('who_editor', :w => @user.name)
    end
    content_tag(:a, content_tag(:b, show), :href => url, :class => 'nava')
  end
    
  def editor_root
    if @user.nil?
      site_url
    else
      site(@user)
    end
  end
  
  def portal_user
    #TODO how to cache @_user?
    @_user = (@user.nil? ? User.find_by_domain('webmaster') : @user) if @_user.nil?
  end

end