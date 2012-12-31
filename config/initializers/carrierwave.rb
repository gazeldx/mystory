CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = Settings.upyun.username
  config.upyun_password = Settings.upyun.password.to_s
  config.upyun_bucket = Settings.upyun.bucket
  config.upyun_bucket_domain = Settings.upyun.bucket_domain
end if Settings[:upyun]