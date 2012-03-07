CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = "gazeldx"
  config.upyun_password = 'zj85918825'
  config.upyun_bucket = "mystory"
  config.upyun_bucket_domain = "mystory.b0.upaiyun.com"
end