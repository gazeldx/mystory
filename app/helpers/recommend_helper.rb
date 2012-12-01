module RecommendHelper

  #TODO refactor
  def recommend_etc(item)
    r = ""
    type = item_type(item)
    count = "(#{item.recommend_count})" unless item.recommend_count == 0
    if session[:id].nil?
      r << (link_to raw("#{t('recommend')}#{count}"), site_url + login_path, :title => t('please_login'))
    else
      r << (link_to "#{t('recommend')}#{count}", 'javascript:;', :id => "recommend_#{type}_#{item.id}", :onclick => "javascript:recommend_#{type}(#{item.id})")
    end
    raw r << "&nbsp;"
  end

  def recommend_etc_in(item)
    r = ""
    type = item_type(item)
    if session[:id].nil?
      r << (link_to t('recommend'), site_url + login_path, :title => t('please_login'))
    else
      r << (link_to t('recommend'), 'javascript:;', :id => "recommend_#{type}_#{item.id}", :onclick => "javascript:recommend_#{type}_in(#{item.id})")
    end
    raw r << (link_to (item.recommend_count == 0 ? "" : "(#{item.recommend_count})"), '#users_box', :title => t('see_recommend_count'), :id => "recommend_#{type}_count", :onclick => "javascript:show_recommend_users()")
  end

  def article_recommend_users
    div_c = content_tag(:span, raw("&nbsp;"), :id => 'users_box')
    content_tag(:div, raw("#{div_c}"), :id => 'article_recommend_users', :style => 'display:none')
  end

  def item_type(item)
    case item
    when Note
      type = 'note'
    when Photo
      type = 'photo'
    when Blog
      type = 'blog'
    when Memoir
      type = 'memoir'
    end
  end
end
