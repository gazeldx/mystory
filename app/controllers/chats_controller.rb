class ChatsController < ApplicationController
  layout 'help'
  skip_before_filter :url_authorize  
  before_filter :group_member
  
  def index
    @chats = @group.chats.order('created_at').limit(200)
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(params[:chat])
    @chat.group = @group
    @chat.user_id = session[:id]
    if @chat.save
      flash[:notice] = t'create_succ'
      redirect_to chat_path
    else
      render :back
    end
  end
end