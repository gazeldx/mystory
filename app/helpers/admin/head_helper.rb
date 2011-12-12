module Admin::HeadHelper
  def navigation_item2(title,link)
    if '/'+controller_path==link || (title==t('home_page') && controller_path=='admin/home')
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
      content_tag(:h3,t(tv))
    end
  end
end