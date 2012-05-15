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
end
