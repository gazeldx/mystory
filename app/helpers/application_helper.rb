module ApplicationHelper
  def title(_title)
    content_for :title do
      _title
    end
  end  
end
