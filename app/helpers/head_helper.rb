module HeadHelper
  def head_query
#    if @user.nil?
#      @user = User.find_by_username(params[:username])
#      #@user = User.where(["username = ?", "gazeldx"]).first
#    end
#    @param = Param.find_by_user_id(@user.id)
#    @menus = Menu.where(["user_id = ?", @user.id]).order('created_at')
  end

  def navigation_item(title,link)
#    puts controller_path
#    puts link
    if controller_path==link || (controller_path=='categories' && link=='news') ||
        (title==t('home_page') && link=='/' && controller_path=='home')
      link_to title,link,:class => "selected"
    else
      link_to title,link
    end
  end
end