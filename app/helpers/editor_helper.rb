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

end
