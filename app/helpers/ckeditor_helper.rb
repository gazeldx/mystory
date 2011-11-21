module CkeditorHelper
  def ckeditor_js(name)
    raw "<script type=\"text/javascript\">\n<!-- /<![CDATA[ -->\nif (CKEDITOR.instances['"+name+"']) {CKEDITOR.remove(CKEDITOR.instances['"+name+"']);}CKEDITOR.replace('"+name+"', { language: 'zh-cn' });\n<!-- /]]> -->\n</script>"
  end
end