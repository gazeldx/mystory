module GroupsHelper
  def group_pic_not_use group
    content_tag(:a, image_tag(group.avatar.thumb.url, width: USER_THUMB_SIZE, height: USER_THUMB_SIZE), href: site(group), title: "#{group.maxim}")
  end

  def college? name
    name.match(/.*(#{t'university'}|#{t'_college'}).*/)
  end
end
