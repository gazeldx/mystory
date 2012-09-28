module RecommendHelper
  #Low efficiency process in Rnote.find_by_user_id_and_note_id.A pay may query so many times!
  def recommend_etc(item)
    r = ""
    #    if controller_path == 'editor'
    #      if item.is_a?(Note)
    #        onclick = "javascript:cancel_recommend_note(#{item.id})"
    #      else
    #        onclick = "javascript:cancel_recommend_blog(#{item.id})"
    #      end
    #    else
    if item.is_a? Note
      onclick = "javascript:recommend_note(#{item.id})"
    elsif item.is_a? Photo
      onclick = "javascript:recommend_photo(#{item.id})"
    elsif item.is_a? Blog
      onclick = "javascript:recommend_blog(#{item.id})"
    end
    r_count = "#{t('recommend')}#{item.recommend_count==0 ? '' : '(' + item.recommend_count.to_s + ')' }"
    #    end
    if session[:id].nil?
      r += link_to r_count, site_url, :title => t('please_login')
    else
      if item.is_a? Note
        #        if Rnote.find_by_user_id_and_note_id(session[:id], item.id).nil?
        r += link_to r_count, 'javascript:;', :id => "recommend_note_#{item.id}", :onclick => onclick
        #        else
        #          r += link_to t('cancel_recommend'), '#' + item.id.to_s, :id => 'recommend' + item.id.to_s, :onclick => onclick
        #        end
      elsif item.is_a? Photo
        #        if Rphoto.find_by_user_id_and_photo_id(session[:id], item.id).nil?
        r += link_to r_count, 'javascript:;', :id => "recommend_photo_#{item.id}", :onclick => onclick
        #        else
        #          r += link_to t('cancel_recommend'), "##{item.id}", :id => "recommend#{item.id}", :onclick => onclick
        #        end
      elsif item.is_a? Blog
        r += link_to r_count, 'javascript:;', :id => "recommend_blog_#{item.id}", :onclick => onclick
        #        r += link_to t('cancel_recommend'), '#' + item.id.to_s, :id => 'recommend-blog' + item.id.to_s, :onclick => onclick
      end
    end
    raw r += "&nbsp;"
  end

  #  def rblogs_cache
  #    cache "side_rblogs_#{@user.id}" do
  #      @rblogs = @user.r_blogs.where(id: @user.blogs.where(:is_draft => false).select('id')).limit(7).order('created_at DESC')
  #    end
  #  end
end
