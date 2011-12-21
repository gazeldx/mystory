module UsersHelper
  def site(user)
    SITE_URL.sub(/\:\/\//, "://" + user.domain + ".")
  end
  
  def my_site
    puts "------------------------------------------------------mysite"
    puts "------------------------------------------------------session[:domain]"+session[:domain]
    SITE_URL.sub(/\:\/\//, "://" + session[:domain] + ".")
  end
end
