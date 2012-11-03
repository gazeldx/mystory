module HeadHelper

  def banner_text
    if controller_path=='notes'
      if controller.action_name=='archives'
        t('s_note_archive', :w => @user.name)
      elsif controller.action_name=='month'
        t('s_note_archive_month', :w => @user.name, m: chinese_month(params[:month]))
      elsif controller.action_name=='show'
        raw "#{@note.title.to_s=='' ? @note.created_at.strftime(t'date_format') : @note.title} - #{link_to @note.notecate.name, @note.notecate} - #{link_to t('s_note', :w => @user.name), notes_path}"
      else
        t('s_note', :w => @user.name)
      end
    elsif controller_path=='blogs'
      if controller.action_name=='archives'
        t('s_blog_archive', :w => @user.name)
      elsif controller.action_name=='month'
        t('s_blog_archive_month', :w => @user.name, m: chinese_month(params[:month]))
      elsif controller.action_name=='show'
        raw "#{@blog.title} - #{link_to @blog.category.name, @blog.category} - #{link_to t('s_blog', :w => @user.name), blogs_path}"
      else
        t('s_blog', :w => @user.name)
      end
    elsif controller_path=='memoirs'
      t('s_memoir', :w => @user.name, c: @memoir.nil? ? "" : @memoir.title)
    elsif controller_path=='editor'
      t('s_editor', :w => @user.name)
    elsif controller_path=='users'
      t('s_my_info', :w => @user.name)
    elsif controller_path=='idols'
      t('s_idol', :w => @user.name)
    elsif controller_path=='hobbies'
      t('s_hobby', :w => @user.name)
    elsif controller_path=='albums'
      if @album.nil? or @album.name.nil?
        t('s_album', :w => @user.name)
      else
        raw "#{@album.name} - #{link_to t('s_album', :w => @user.name), albums_path}"
      end
    elsif controller_path=='photos'
      if controller.action_name=='index'
        t('s_recent_photos', :w => @user.name)
      else
        raw "#{@photo.description.to_s=='' ? t('_photo_title')+@photo_position.to_s : @photo.description[0..17]} - #{link_to @album.name, @album} - #{link_to t('s_album', :w => @user.name), albums_path}"
      end
    elsif controller_path=='categories'
      if controller.action_name=='index'
        t('s_categories', :w => @user.name)
      elsif controller.action_name=='edit'
        t'category.edit'
      else
        raw "#{@category.name} - #{link_to t('s_blog', :w => @user.name), blogs_path}"
      end
    elsif controller_path=='notecates'
      if controller.action_name=='index'
        t('s_notecates', :w => @user.name)
      elsif controller.action_name=='edit'
        t'notecate.edit'
      else
        raw "#{@notecate.name} - #{link_to t('s_note', :w => @user.name), notes_path}"
      end
    elsif controller_path=='tags'
      if params[:name].nil?
        t('tags_who', :w => @user.name)
      else
        t('tag_who', :w => params[:name], n: @user.name)
      end
    elsif controller_path=='posts'
      if controller.action_name=='bbs'
        t('whose_topic', :w => @user.name)      
      else
        t('whose_reply_topic', :w => @user.name)
      end
    elsif controller_path=='comments'
      if controller.action_name=='commented'
        t('s_commented_by_friend', :w => @user.name)
      else
        t('commented_by_self', :w => @user.name)
      end
    elsif controller_path=='like'
      t('active_state', :w => @user.name)
    elsif controller_path=='archives'
      if controller.action_name=='index'
        t('s_archive', :w => @user.name)
      else
        t('s_archive_month', :w => @user.name, m: chinese_month(params[:month]))
      end
    else
      @user.name
    end
    #TODO add title here show maxim.
  end

  def group_banner_text
#    puts controller_path
#    puts controller.action_name
    if controller_path == 'gcolumns'
      if controller.action_name == 'show'
        t('a_b', a: @gcolumn.name, b: @group.name)
      end
    else
      if controller.action_name == 'about'
        t('a_b', a: t('_introduce'), b: @group.name)
      else
        @group.name
      end
    end
  end

  def navigation_item(title,link)
    if "/" + controller_path==link || (controller_path=='categories' && link==blogs_path)
      link_to title, link, :class => "selected"
    else
      link_to title, link
    end
  end

  def navigation_group(title, link)
    if "/#{controller_path}" == link
      link_to title, link, :class => "selected"
    else
      link_to title, link
    end
  end
end