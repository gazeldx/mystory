module RecommendHelper
  
  def recommend_etc(item)
    r = ""
    if item.is_a? Note
      onclick = "javascript:recommend_note(#{item.id})"
    elsif item.is_a? Photo
      onclick = "javascript:recommend_photo(#{item.id})"
    elsif item.is_a? Blog
      onclick = "javascript:recommend_blog(#{item.id})"
    end
    r_count = "#{t('recommend')}#{item.recommend_count==0 ? '' : '(' + item.recommend_count.to_s + ')' }"
    if session[:id].nil?
      r += link_to r_count, site_url, :title => t('please_login')
    else
      if item.is_a? Note        
        r += link_to r_count, 'javascript:;', :id => "recommend_note_#{item.id}", :onclick => onclick
      elsif item.is_a? Photo
        r += link_to r_count, 'javascript:;', :id => "recommend_photo_#{item.id}", :onclick => onclick
      elsif item.is_a? Blog
        r += link_to r_count, 'javascript:;', :id => "recommend_blog_#{item.id}", :onclick => onclick
      #TODO Need add momoir here
      end
    end
    raw r += "&nbsp;"
  end

end
