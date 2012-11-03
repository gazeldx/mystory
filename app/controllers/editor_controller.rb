class EditorController < ApplicationController
  layout 'memoir'
  def index
#    @rnotes = @user.rnotes.order('created_at DESC').limit(20)
#    @rblogs = @user.rblogs.order('created_at DESC').limit(20)
    render :layout => 'portal'
  end

end
