module GroupsHelper
  def group_pic_not_use group
    content_tag(:a, image_tag(group.avatar.thumb.url, width: USER_THUMB_SIZE, height: USER_THUMB_SIZE), href: site(group), title: "#{group.maxim}")
  end

  def college? name
    name.match(/.*(#{t'university'}|#{t'_college'}).*/)
  end

  def show_schools
    s = ""
    @school_groups.each do |group|
      if group.member_count >= MIN_COLLEGE_MEMBER
         s += link_to group.name, site(group), target: '_blank'
      else
         s += group.name
      end
      s += "&nbsp;&nbsp;&nbsp;"
    end
    raw s
  end
end
