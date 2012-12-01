module EditorHelper
 
  def editor_it item
    r = ""
    count = content_tag(:span, "(#{item.columns_count})") unless item.columns_count == 0
    if session[:id].nil?
      r << (link_to t('editor_it'), site_url + login_path, :title => t('please_login'))
    else
      r << (link_to t('editor_it'), 'javascript:;', :id => "editor_a", :onclick => "javascript:show_editor_columns()", :title => t('click_edit_this'))
    end
    r << (link_to count, 'javascript:;', :id => "columns_count", :onclick => "javascript:show_article_editors()", :title => t('see_editors_count')) unless count.nil?
    raw r
  end

  def editor_box item
    div_c = content_tag(:span, "", :class => 'green', :id => 'ctips')
    div_c += hidden_field_tag 'article_id', item.id
    type = item_type(item)
    div_c += hidden_field_tag 'stype', type
    div_c += content_tag(:span, raw("&nbsp;"), :id => 'columns_box', :style => 'height:260')
    content_tag(:div, div_c, :id => 'editor_columns', :class => 'b rr', :style => 'display:none')
  end

  def article_editors
    div_c = content_tag(:span, raw("&nbsp;"), :id => 'editors_box', :style => 'height:160')
    content_tag(:div, raw("#{div_c}"), :id => 'article_editors', :class => 'b rr', :style => 'display:none')
  end
end
