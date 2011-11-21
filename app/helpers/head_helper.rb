module HeadHelper
  def head_query
    if @user==nil
      @user = User.where(["username = ?", params[:username]]).first
      #@user = User.where(["username = ?", "gazeldx"]).first
    end
  end
end
