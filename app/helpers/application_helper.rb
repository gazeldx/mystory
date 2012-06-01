module ApplicationHelper
  def title(_title)
    content_for :title do
      _title
    end
  end

  def summary(_summary)
    content_for :summary do
      _summary.gsub(/\r\n/,' ')
    end
  end

  def h(_title)
    content_for :h do
      _title
    end
  end

  def validate_form(form_id)
    raw "<script type=\"text/javascript\">$(document).ready(function(){$('##{form_id}').validate();});</script>"
  end

  #month as 201204
  def chinese_month(month)
    month[0..3] + t('year') + month[4..5] + t('month')
  end

  def u_link_to(text, item)
    if item.is_a?(Note)
      path = note_path(item)
    elsif item.is_a?(Blog)
      path = blog_path(item)
    end
    link_to text, site(item.user) + path
  end

  def m_link_to(text, item)
    if item.is_a?(Note)
      path = note_path(item)
    elsif item.is_a?(Blog)
      path = blog_path(item)
    elsif item.is_a?(Category)
      path = category_path(item)
    elsif item.is_a?(Notecate)
      path = notecate_path(item)
    end
    link_to text, m(site(item.user) + path)
  end
end
