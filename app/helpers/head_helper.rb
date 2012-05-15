module HeadHelper

  def banner_text
    #puts controller_path
    #puts controller.action_name
    if controller_path=='notes'
      if controller.action_name=='archives'
        t('s_note_archive', w: @user.name)
      elsif controller.action_name=='month'
        t('s_note_archive_month', w: @user.name, m: chinese_month(params[:month]))
      else
        t('s_note', w: @user.name)
      end
    elsif controller_path=='blogs'
      if controller.action_name=='archives'
        t('s_blog_archive', w: @user.name)
      elsif controller.action_name=='month'
        t('s_blog_archive_month', w: @user.name, m: chinese_month(params[:month]))
      else
        t('s_blog', w: @user.name)
      end
    elsif controller_path=='memoirs'
      t('s_memoir', w: @user.name, c: @memoir.nil? ? "" : @memoir.title)
    elsif controller_path=='editor'
      t('s_editor', w: @user.name)
    elsif controller_path=='users'
      t('s_my_info', w: @user.name)
    elsif controller_path=='idols'
      t('s_idol', w: @user.name)
    elsif controller_path=='hobbies'
      t('s_hobby', w: @user.name)
    elsif controller_path=='albums'
      if @album.nil? or @album.name.nil?
        t('s_album', w: @user.name)
      else
        t('s_album_in', w: @user.name, w2: @album.name)
      end
    elsif controller_path=='photos'
      if controller.action_name=='index'
        t('s_recent_photos',w: @user.name)
      else
        t('s_album_in', w: @user.name, w2: @album.name)
      end
    elsif controller_path=='categories'
      if controller.action_name=='index'
        t('s_categories', w: @user.name)
      elsif controller.action_name=='edit'
        t'category.edit'
      else
        t('s_category', w: @user.name, w2: @category.name)
      end
    elsif controller_path=='notecates'
      if controller.action_name=='index'
        t('s_notecates', w: @user.name)
      elsif controller.action_name=='edit'
        t'notecate.edit'
      else
        t('s_notecate', w: @user.name, w2: @notecate.name)
      end
    elsif controller_path=='tags'
      if params[:name].nil?
        t('tags_who', w: @user.name)
      else
        t('tag_who', w: params[:name], n: @user.name)
      end
    elsif controller_path=='posts'
      if controller.action_name=='bbs'
        t('whose_topic', w: @user.name)      
      else
        t('whose_reply_topic', w: @user.name)
      end
    elsif controller_path=='comments'
      if controller.action_name=='commented'
        t('s_commented_by_friend', w: @user.name)
      else
        t('commented_by_self', w: @user.name)
      end
    elsif controller_path=='like'
      t('active_state', w: @user.name)
    else
      @user.name
    end
    #TODO add title here show maxim.
  end

  def navigation_item(title,link)
    if "/" + controller_path==link || (controller_path=='categories' && link==blogs_path)
      link_to title,link,:class => "selected"
    else
      link_to title,link
    end
  end
end