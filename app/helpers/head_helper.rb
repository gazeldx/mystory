module HeadHelper
  def head_query
    if @user==nil
      @user = User.where(["username = ?", params[:username]]).first
      #@user = User.where(["username = ?", "gazeldx"]).first
    end
  end

  def navigation_item(controller,title,link)
    if controller_path==controller || (controller_path=='categories' && controller=='news')
      link_to title,link,:class => "selected"
    else
      link_to title,link
    end
  end
end