module EditorHelper
 
  def editor_it item
    r = ""
    onclick = "javascript:show_editor_columns()"
    #    r_count = "#{t('recommend')}#{item.recommend_count==0 ? '' : '(' + item.recommend_count.to_s + ')' }"
    r_count = "#{t('editor_it')}"
    if session[:id].nil?
      r += link_to r_count, site_url + login_path, :title => t('please_login')
    else
      if item.is_a? Note
        r += link_to r_count, 'javascript:;', :id => "editor_note_#{item.id}", :onclick => onclick
      elsif item.is_a? Blog
        r += link_to r_count, 'javascript:;', :id => "editor_blog_#{item.id}", :onclick => onclick
      end
      raw r += "&nbsp;"
    end
  end

  def editor_box item
    unless session[:id].nil?
      div_c = content_tag(:span, "", :class => 'green', :id => 'ctips')
      div_c += hidden_field_tag 'article_id', item.id
      if item.is_a? Note
        type = 'note'
      else
        type = 'blog'
      end
      div_c += hidden_field_tag 'stype', type
      div_c += content_tag(:span, "&nbsp;", :id => 'columns_box', :style => 'height:160')
      content_tag(:div, div_c, :id => 'editor_columns', :class => 'rr', :style => 'display:none')
    end
  end
end
