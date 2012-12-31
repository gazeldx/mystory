class UserMailer < ActionMailer::Base
  #  default from: "mail_zlj@163.com"
  default from: "zjloveztt@gmail.com"

  def welcome_new_user(user)
    @user = user
    puts "--begin mail sending at welcome_new_user(#{@user.email})...."
    mail(:to => @user.email, :subject => t('mail.subject.welcome_new_user', :w => @user.name))
    puts "--end mail sent"
  end

  def note_21days(user)
    @user = user
    puts "--begin mail sending at note_21days(#{@user.email})...."
    mail(:to => @user.email, :subject => t('mail.subject.note_21days', :w => @user.name))
    puts "--end mail sent"
  end
  
  def new_function(user)
    @user = user
    puts "--begin mail sending at new_function(#{@user.email})...."
    mail(:to => @user.email, :subject => t('mail.subject.new_function', :w => @user.name))
    puts "--end mail sent"
  end  
end
