ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => Settings.aws_access_key_id,
  :secret_access_key => Settings.aws_secret_access_key