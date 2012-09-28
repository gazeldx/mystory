class MailsController < ApplicationController
  before_filter :super_admin
  layout 'help'
  
  def new_function_email
    get_users
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

  def note_21days_email
    get_users
    #      @users = User.find([13, 14])
    puts @users.inspect
    @users.each do |user|
      if user.email.match(/.*mystory\.cc/)
        puts ">>>>>>>>>>>>>>>>not send #{user.email}"
      else
        UserMailer.note_21days(user).deliver
        logger.info("Email sent to #{user.email} from new_function_email")
      end
    end
    render :new_function_email
  end

  private
  def get_users
    @users = User.where(["id >= ? AND id <= ?", params[:start], params[:end]]).order("id DESC")
  end
end