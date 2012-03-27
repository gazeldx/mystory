module ApplicationHelper
  def title(_title)
    content_for :title do
      _title
    end
  end

  def validate_form(form_id)
    raw "<script type=\"text/javascript\">$(document).ready(function(){$('##{form_id}').validate();});</script>"
  end

end
