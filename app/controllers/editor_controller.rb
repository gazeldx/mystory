class EditorController < ApplicationController

  def index
    @rnotes = @user.rnotes.order('created_at DESC').limit(20)
    @rblogs = @user.rblogs.order('created_at DESC').limit(20)
  end

end
