weibo_config = YAML.load_file("#{Rails.root}/config/weibo.yml")[Rails.env]

Weibo::Config.api_key = weibo_config['api_key']
Weibo::Config.api_secret = weibo_config['api_secret']