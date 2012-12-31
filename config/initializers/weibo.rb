if Settings[:weibo]
  WeiboOAuth2::Config.api_key = Settings.weibo.api_key
  WeiboOAuth2::Config.api_secret = Settings.weibo.api_secret
end