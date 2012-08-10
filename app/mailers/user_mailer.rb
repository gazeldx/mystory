class UserMailer < ActionMailer::Base
  default from: "zj137@163.com"

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    puts "begin now send mailing...."
    mail(from: "mystory.cc <mail_zlj@163.com>", :to => "mail_zlj@163.com", :subject => "mystory.cc welcome you!")
    puts "mail sent ,haha!"
    #      mail from: "#{shop.name} <#{shop.email}>", to: email, subject: subject, body: body, content_type: email_template.content_type
  end
  #  require "aws/ses"
  #  def welcome_email(user)
  ##    ses = AWS::SES::Base.new( ... connection info ... )
  #    ses.send_email :to        => ['jon@example.com', 'dave@example.com'],
  #      :source    => '"Steve Smith" <steve@example.com>',
  #      :subject   => 'Subject Line'
  #    :text_body => 'Internal text body'
  #  end
end
