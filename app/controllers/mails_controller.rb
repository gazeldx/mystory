class MailsController < ApplicationController
  before_filter :super_admin
  layout 'help'
  
  def new_function_email
    @users = User.where(["id >= ? AND id <= ?", params[:start], params[:end]]).order("id DESC")
    #      @users = User.find([13, 14])
    puts @users.inspect
    @users.each do |user|
      if user.email.match(/.*mystory\.cc/)
        puts ">>>>>>>>>>>>>>>>not send #{user.email}"
      else
        #        sleep(1.seconds) this will block all the web app.So I need use github.com delay_job
        UserMailer.new_function(user).deliver
        puts "------------------- email sent "
        logger.info("Email sent to #{user.email}")
      end
    end
  end
end