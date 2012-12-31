module OpenHelper

  def weibo_login_image
    content_tag(:a, image_tag("#{YUN_IMAGES}weibo_login.png", width: 126, height: 24), :href => weibo_connect_path, :title => t('weibo_login_tip')) if need_bind_weibo?
  end

  def qq_login_image
    content_tag(:a, image_tag("#{YUN_IMAGES}qq_login.png", width: 63, height: 24), :href => qq_connect_path, :title => t('qq_login_tip')) if need_bind_qq?
  end

  def need_bind_weibo?
    Settings[:weibo] and session[:atoken].nil?
  end

  def need_bind_qq?
    Settings[:qq] and session[:token].nil?
  end

end
