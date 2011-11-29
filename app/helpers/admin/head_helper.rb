module Admin::HeadHelper
  def navigation_item2(controller,title,link)
    puts controller_path
    puts admin_portions_path
    if controller_path=="admin/"+controller || (controller_path=='admin/portions' && controller=='home')
      link_to title,link,:class => "selected"
    else
      link_to title,link
    end
  end

  def tip_info
    if /.+\/edit\z/=~request.url
      tv='edit'
    elsif /.+\/new\z/=~request.url
      tv='new'
    else
      tv='list'
    end
    if tv!='list'
      content_tag(:h1,t(tv))
    end
  end
end