class UserMailer < ActionMailer::Base
  default from: "zj137@163.com"

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "mystory.cc welcome you!")
  end
  
end
