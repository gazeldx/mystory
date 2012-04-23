module HeadHelper

  def banner_text
#    if ['home','like'].include?controller_path
#      @user.name
    if controller_path=='notes'
      t('s_note', w: @user.name)
    elsif controller_path=='blogs'
      t('s_blog', w: @user.name)
    elsif controller_path=='memoirs'
      t('s_memoir', w: @user.name, c: @memoir.title)
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