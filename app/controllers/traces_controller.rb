class TracesController < ApplicationController
  before_filter :super_admin
  layout 'help'
  include Sina
  
  def index
    @user_hash = USER_HASH
  end

  def start_trace_sina_users_latest_blogs
    USER_HASH.each do |k, v|
      trace_a_sina_user_latest_blogs(v)
    end
    head :ok
  end

  def trace_a_sina_user_latest_blogs(sina_user_id)
    source = Net::HTTP.get('blog.sina.com.cn', "/s/articlelist_#{sina_user_id}_0_1.html")
    return false if source.nil?
    m = source.match(/.*START --(.*).*SG_page.*/m)
    m_links = m[1].scan(/(http:\/\/blog.sina.com.cn\/s\/blog_(.*?)\.html)/m)
    m_links.each_with_index do |e, i|
      s = Net::HTTP.get('blog.sina.com.cn', "/s/blog_#{e[1]}.html")
      if Tracemap.where(["siteid = ? AND sitename = ?", e[1], 'sina']).exists?
        break
      else
        sina_article(s, sina_user_id, e[1])
      end
    end
  end

  def start_trace_sina_user_one_list
    trace_a_sina_user_one_list_blogs(params[:sina_user_id], params[:page_id])
    head :ok
  end

  def start_trace_sina_user_all_list
    trace_a_sina_user_all_blogs(params[:sina_user_id])
    head :ok
  end

  def start_trace_sina_user_two_list
    trace_a_sina_user_one_list_blogs(params[:sina_user_id], params[:page_id])
    trace_a_sina_user_one_list_blogs(params[:sina_user_id], params[:page_id].to_i - 1)
    head :ok
  end

  def trace_a_sina_user_all_blogs(sina_user_id)
    k = 0
    loop {
      k = k + 1
      one_list = trace_a_sina_user_one_list_blogs(sina_user_id, k)
      break if one_list==false
    }
  end

  def trace_a_sina_user_one_list_blogs(sina_user_id, k)
    source = Net::HTTP.get('blog.sina.com.cn', "/s/articlelist_#{sina_user_id}_0_#{k}.html")
    return false if source.nil?
    m = source.match(/.*START --(.*).*SG_page.*/m)
    m_links = m[1].scan(/(http:\/\/blog.sina.com.cn\/s\/blog_(.*?)\.html)/m)
    m_links.each_with_index do |e, i|
      s = Net::HTTP.get('blog.sina.com.cn', "/s/blog_#{e[1]}.html")
      unless Tracemap.where(["siteid = ? AND sitename = ?", e[1], 'sina']).exists?
        sina_article(s, sina_user_id, e[1])
      end
    end
  end  

  def clear_user_blogs
    user = User.find_by_domain(params[:domain])
    user.blogs.destroy_all
    head :ok
  end

  private
  def new_category(category_name, user)
    cate = Category.new
    puts "=======================================create category,category_name=#{category_name}"
    cate.name = category_name
    cate.user = user
    cate.save
    cate
  end

  def sina_article(s, sina_user_id, article_id)
    puts title = s.match(/<h2 id=.*>(.*)<\/h2>/)[1].gsub(/&nbsp;/, " ")
    #TODO 转型，转为，转变，转让，转弯 IS OK
    unless title.force_encoding('utf-8').include?("#{t('copy_article')}")
      begin
        #TODO start and end \n should be replaced.
        puts content = s.match(/sina_keyword_ad_area2" class="articalContent  ">(.*)<div class="shareUp/m)[1].gsub(/<span class='MASS.*?<\/span>/m, "").gsub(/<\/?[^>]*>/,"").gsub(/<\/?[^>]*>/,"").gsub(/&nbsp;/, " ").gsub(/\n[ \n]{2,15}/, "\n\n ").gsub(/http/, " http")
        user_id = USER_HASH.invert[sina_user_id.to_i]
        #      puts tags = s.match(/<span class="SG_txtb">.*<\/span>.*sina_keyword_ad_area2" class="articalContent  ">(.*)
        puts "------------------------category td ="
        puts _category_td = s.match(/blog_class(.*?)<\/td>/m)[1]
        puts _category = _category_td.match(/.*html">(.*?)<\/a>/m)[1] unless _category_td.size < 15
        puts created_at = s.match(/time SG_txtc">\((.*?)\)/)[1]

        blog = Blog.new
        blog.title = title[0..80]
        blog.content = content[0..100000]

        user = User.find(user_id)
        blog.user = user

        categories = user.categories
        if _category.nil?
          if categories.blank?
            category = new_category(t('default_category_name'), user)
          else
            category = categories.first
          end
        else
          category = categories.find_by_name(_category)
          category = new_category(_category, user) if category.nil?
        end
        blog.category = category

        blog.created_at = Time.zone.parse(created_at)#http://stackoverflow.com/questions/354657/rails-activesupport-time-parsing
        blog.updated_at = blog.created_at
        blog.save
        tracemap = Tracemap.new
        tracemap.siteid = article_id
        tracemap.blog = blog
        tracemap.sitename = 'sina'
        tracemap.save
        logger.info("-----Sina #{user.name} blog id=#{article_id}, #{title} traced over!")
      rescue
        logger.warn("---Trace failed in trace_a_sina_user_one_list_blogs. blog id=#{article_id}, title=#{title}")
      end
    end
  end
end
