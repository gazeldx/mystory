class BlogObserver < ActiveRecord::Observer
  #TODO after_create will do before blog.save! Is that a bug?
  def after_create(blog)
    puts "enter after_create now......"
#    if Rails.env.production?
    if 1
      unless blog.is_draft
        puts "enter send weibo qq now......"
        user = blog.user
        if user.atoken
#          begin
            oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret).authorize_from_access(user.atoken, user.asecret)
            str = "#{blog.title} - "
            data = "#{str}#{text_it_pure(blog.content)[0..130-str.size]}#{site(user) + blog_path(blog)}"
            Weibo::Base.new(oauth).update(data)
            puts "weibo sent ......"
#          rescue
#            Rails.logger.warn("---Send_blog_to_weibo blog.id=#{blog.id} failed.Data is #{data} atoken=#{user.atoken}")
#          end
        end

        if user.token
          begin
            qq = Qq.new
            auth = qq.gen_auth(user.token, user.openid)
            text = text_it_pure(blog.content)
            url = site(user) + blog_path(blog)
            comment = text[0..40]
            summary = "...#{text[41..160]}"
            #TODO image pengyou.com no data.来自不对
            qq.add_share(auth, blog.title, url, comment, summary, "", '1', site(user), '', '')
            puts "qq sent ......"
            #        str = "#{blog.title} - "
            #        data = "#{str}#{text[0..130-str.size]}#{url}"
            #        qq.add_t(auth, '', '', '', '1', "testweibohaihihihih")
            #        def add_share(auth,title,url,comment,summary,images,source,site,nswb,*play)
            #          data=auth + '&title=' + title + '&url=' + url + '&comment=' + comment + '&summary=' + summary + '&images=' + images + '&source=' + source + '&site=' + site + '&nswb=' + nswb + '&type=' + play[0]
            #          data=data + '&playurl=' + play[1] unless play.count ==1
            #          MultiJson.decode(post_comm(ADDSHAREURL,URI.escape(data)))
            #        end
          rescue
            Rails.logger.warn("---Send_blog_to_qq blog.id=#{blog.id} failed.Data is #{url}, #{comment}, #{summary}, #{auth} ")
          end
        end
      end
    end
  end
  
end