module HeadHelper
  def head_query
#    if @user.nil?
#      @user = User.find_by_username(params[:username])
#      #@user = User.where(["username = ?", "gazeldx"]).first
#    end
#    @param = Param.find_by_user_id(@user.id)
#    @menus = Menu.where(["user_id = ?", @user.id]).order('created_at')
  end

  def banner_text
    if ['home','like'].include?(controller_path)
      @user.name
    elsif controller_path=='notes'
      t('s_note',w: @user.name)
    elsif controller_path=='blogs'
      t('s_blog',w: @user.name)
    elsif controller_path=='memoirs'
      t('s_memoir',w: @user.name)
    end
  end

  def navigation_item(title,link)
    if "/" + controller_path==link || (controller_path=='categories' && link==blogs_path)
      link_to title,link,:class => "selected"
    else
      link_to title,link
    end
  end
end