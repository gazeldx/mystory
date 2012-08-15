class MailsController < ApplicationController
  before_filter :super_admin
  layout 'help'
  
  def new_function_email
    if ENV["RAILS_ENV"] == "production"
      users = User.all
    else
#      users = User.find([12, 13, 14])
      users = User.find([13, 14])
    end
    users.each do |user|
      if user.email.match(/.*mystory\.cc/)
        puts ">>>>>>>>>>>>>>>>not send #{user.email}"
      else
        #        sleep(1.seconds) this will block all the web app.So I need use github.com delay_job
        UserMailer.new_function(user).deliver
        puts "------------------- email sent "
      end
    end
  end
end