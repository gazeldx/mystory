module BlogsHelper
  
  def blog_info(blog)
    info = blog.created_at.strftime t('time_format')
    info += ' ' + t('posted_in') + ' ['
    info += link_to blog.category.name, blog.category, title: t('view_blogs_in_category')
    info += '] '
    if blog.created_at.strftime(t('date_format')) != blog.updated_at.strftime(t('date_format'))
      info += blog.updated_at.strftime(t('time_format')) + t('update')
    end
    raw info
  end

  def updated_tag_info(blog)
    info = ""
    if blog.created_at.strftime(t('date_format')) != blog.updated_at.strftime(t('date_format'))
      info += blog.updated_at.strftime(t('time_format')) + t('update')
    end
    info + ' ' + join_tags(blog)
  end

  def blog_info2(blog)
    info = blog.created_at.strftime t('date_without_year') + ' '
    info += link_to blog.category.name, blog.category, title: t('view_blogs_in_category')
    raw info
  end

  def article_time(item)
    r = ""
    if params[:t] == 'updated' or item.is_a?(Memoir)
      r = item.updated_at.strftime t'no_year'
      r += t'update'
    else
      r = item.created_at.strftime t'no_year'
    end
    r
  end

  def join_tags(item)
    unless item.tags.blank?
      _tags = item.tags.map { |t|
        link_to t.name, "/tags/" + t.name
      }.join(", ")
      raw (t('_tag_') + _tags)
    end
  end

  def join_notetags(item)
    unless item.notetags.blank?
      _tags = item.notetags.map { |t|
        link_to t.name, "/tags/" + t.name
      }.join(", ")
      raw (t('_tag_') + _tags)
    end
  end

  def meta_desc_blog_list
    r = t'_category_'
    @categories.each do |category|
      r += "[#{category.name}] "
    end
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_blogs'}"
    @blogs.each_with_index do |blog, i|
      break if i>11
      r += "#{t'left_book'}#{blog.title}#{t'right_book'}"
    end
    raw r
  end

  def meta_desc_note_list
    r = t'_notecate_'
    @notecates.each do |category|
      r += "[#{category.name}] "
    end
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_notes'}"
    @notes.each_with_index do |note, i|
      break if i>12
      r += "#{note.title.to_s=='' ? note.created_at.strftime(t'date_format') : note.title}#{t'dunhao'}"
    end
    raw r
  end

  def meta_desc_category_show
    r = "#{t'_category_'}[#{@category.name}]"
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_blogs'}"
    @blogs.each_with_index do |blog, i|
      break if i>12
      r += "#{t'left_book'}#{blog.title}#{t'right_book'}"
    end
    raw r
  end

  def meta_desc_notecate_show
    r = "#{t'_notecate_'}[#{@notecate.name}]"
    r += "&nbsp;&nbsp;&nbsp;#{t'_latest_notes'}"
    @notes.each_with_index do |note, i|
      break if i>13
      r += "#{note.title.to_s=='' ? note.created_at.strftime(t'date_format') : note.title}#{t'dunhao'}"
    end
    raw r
  end

  def meta_desc_albums
    r = t'_all_albums'
    @albums.each_with_index do |album, i|
      r += "[#{album.name}] "
    end
    r += " " + t('user_meta_album_c', w: @user.name)
    raw r
  end

  def meta_desc_album_show
    r = "#{t('_w_album_of', a: @album.name, w: @user.name)} "
    unless @photos.blank?
      r += t('_album_desc', n: @photos.size)
    end
    r += " #{@album.description}#{t'_metadesc_plug'}"
    raw r
  end

  def meta_desc_photo
    r = t('_upload_at', w: @photo.created_at.strftime(t'date_format'))
    r += " " + t('photo_title_desc', p: @photo.description, a: @album.name, w: @user.name)
  end

  def meta_desc_user
    r = "#{@user.name} #{@user.city} #{@user.jobs} #{@user.maxim.to_s=='' ? "": "#{t'maxim'}:#{@user.maxim}"} "
    @user.hobbies.each_with_index do |hobby, i|
      r += t'_hobby_' if i==0
      r += "#{hobby.name} "
    end
    r += @user.memo.to_s=='' ? "": "&nbsp;#{t'_simple_desc'}#{@user.memo}"
    r += " " + t('user_meta_desc_c', w: @user.name)
    raw r
  end
end