CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = "gazeldx"
  config.upyun_password = 'zj85918825'
  config.upyun_bucket = "mystorytest"
  config.upyun_bucket_domain = "mystorytest.b0.upaiyun.com"
end