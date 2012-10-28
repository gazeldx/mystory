class MessagesController < ApplicationController
  layout 'help'
  
#  before_filter :url_authorize, :only => [:index]

  def index
    @messages = @user.messages.order("created_at DESC")

    @view_messages_at = @user.view_messages_at
    @user.update_attribute('view_messages_at', Time.now)
    @user.update_attribute('unread_messages_count', 0)
  end
  
end