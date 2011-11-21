module ErrorHelper
  def error_msg(mo)
    if mo.errors.any?
      full_msg=""
      mo.errors.full_messages.each do |msg|
        full_msg=full_msg+"<li>"+msg+"</li>"
      end
      raw "<div id=\"error_explanation\">
      <h2>"+pluralize(mo.errors.count, t(:num_error))+t(:op_error)+"</h2>
      <ul>"+full_msg+"</ul></div>"
    end
  end
end