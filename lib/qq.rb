#encoding=utf-8
#以下不需要改动
AUTHURL='https://graph.qq.com/oauth2.0/authorize?'
TOKENURL='https://graph.qq.com/oauth2.0/token?'
OPENIDURL='https://graph.qq.com/oauth2.0/me?access_token='
GETUSERINFOURL='https://graph.qq.com/user/get_user_info?'
ADDSHAREURL='https://graph.qq.com/share/add_share'
CHECKPAGEFANSURL='https://graph.qq.com/user/check_page_fans?'
ADDTURL='https://graph.qq.com/t/add_t'
ADDPICTURL='https://graph.qq.com/t/add_pic_t'
DELTURL='https://graph.qq.com/t/del_t'
GETREPOSTLISTURL='https://graph.qq.com/t/get_repost_list?'
GETINFOURL='https://graph.qq.com/user/get_info?'
GETOTHERINFOURL='https://graph.qq.com/user/get_other_info?'
GETFANSLISTURL='https://graph.qq.com/relation/get_fanslist?'
GETIDOLLISTURL='https://graph.qq.com/relation/get_idollist?'
ADDIDOLURL='https://graph.qq.com/relation/add_idol'
DELIDOLURL='https://graph.qq.com/relation/del_idol'

require 'net/http'
require 'uri'
require 'open-uri'
require 'rest-client'
require 'multi_json'

class Qq
	attr_reader :token, :openid, :auth
  
	def gen_auth(token, openid)
    "access_token=#{token}&oauth_consumer_key=#{APPID}&openid=#{openid}"
  end

	#点击登陆按钮跳转地址
	def Qq.redo(scope)
		AUTHURL + 'response_type=code&client_id='+ APPID + REDURL + '&scope=' + scope
	end
	
	#获取令牌:认证码code=params[:code],httpstat=request.env['HTTP_CONNECTION']
	def get_token(code,httpstat)
    #获取令牌
		@token=open(TOKENURL + 'grant_type=authorization_code&client_id=' + APPID + '&client_secret=' + APPKEY + '&code=' + code + '&state='+ httpstat + REDURL).read[/(?<=access_token=)\w{32}/]
		#获取Openid
		@openid=open(OPENIDURL + @token).read[/\w{32}/]
		#获取通用验证参数
		@auth='access_token=' + @token + '&oauth_consumer_key=' + APPID + '&openid=' + @openid
	end
	
	#post包的通用模版,用于没有附件的情况
	#url:发送的网址
	#data:数据
	def post_comm(url,data)
		com=URI.parse(url)
		if url.include?'https://'
			res=Net::HTTP.new(com.host,443)
			res.use_ssl=true
		else
			res=Net::HTTP.new(com.host)
		end
		res=res.post(com.path,data).body
	end
	
	#获取用户信息:比如figureurl,nickname
	def get_user_info(auth)
		MultiJson.decode(open(GETUSERINFOURL + auth).read.force_encoding('utf-8'))
	end

	#发表一条说说到QQ空间
	def add_topic(auth,type)
		
	end
	
	#同步分享到QQ空间、朋友网、腾讯微博
	def add_share(auth,title,url,comment,summary,images,source,site,nswb,*play)
		data=auth + '&title=' + title + '&url=' + url + '&comment=' + comment + '&summary=' + summary + '&images=' + images + '&source=' + source + '&site=' + site + '&nswb=' + nswb + '&type=' + play[0]
		data=data + '&playurl=' + play[1] unless play.count ==1
		MultiJson.decode(post_comm(ADDSHAREURL,URI.escape(data)))
	end
	
	#验证登录的用户是否为某个认证空间的粉丝
	#page_id:认证空间的QQ号码,比如706290240
	def check_page_fans(auth,page_id)
		MultiJson.decode(open(CHECKPAGEFANSURL + auth + '&page_id=' + page_id).read.force_encoding('utf-8'))
	end
	
	#发表一条微博信息到腾讯微博
	def add_t(auth,clientip,jing,wei,syncflag,content)
		MultiJson.decode(post_comm(ADDTURL,URI.escape(auth + '&clientip=' + clientip + '&jing=' + jing + '&wei=' + wei + '&syncflag=' + syncflag + '&content=' + content)))
	end

	#上传图片并发表消息到腾讯微博
	def add_pic_t(token,openid,clientip,jing,wei,syncflag,content,pic)
		MultiJson.decode(RestClient.post(ADDPICTURL,
													:access_token=>token,
													:oauth_consumer_key=>APPID,
													:openid=>openid,
													:clientip=>clientip,
													:jing=>jing,
													:wei=>wei,
													:syncflag=>syncflag,
													:content=>content,
													:pic=>pic))
	end
	
	#删除一条微博
	#id:被删除的微博号
	def del_t(auth,id)
		data=auth + '&id=' + id
		MultiJson.decode(post_comm(DELTURL,URI.escape(data)))
	end

	#获取一条微博的转播或评论信息列表
	def get_repost_list(auth,flag,rootid,pageflag,pagetime,reqnum,twitterid)
		MultiJson.decode(open(GETREPOSTLISTURL + auth + '&flag=' + flag +
				 						   '&rootid=' + rootid +
				 						   '&pageflag=' + pageflag +
				 						   '&pagetime=' + pagetime +
				 						   '&reqnum=' + reqnum +
				 						   '&twitterid=' + twitterid).read)
	end

	#获取腾讯微博登录用户的用户资料
	def get_info(auth)
		MultiJson.decode(open(GETINFOURL + auth).read.force_encoding('utf-8'))
	end

	#获取腾讯微博其他用户详细信息
	#name=其他用户账号名或openid,格式为name=peter或fopenid=******
	def get_other_info(auth,name)
		MultiJson.decode(open(GETOTHERINFOURL + auth + '&' + name).read.force_encoding('utf-8'))			
	end

	#获取登录用户的听众列表
	def get_fanslist(auth,reqnum,startindex,mode,install)
		MultiJson.decode(open(GETFANSLISTURL + auth + '&reqnum=' + reqnum + '&startindex=' + startindex + '&mode=' + mode + '&install=' + install))
	end

	#获取登录用户收听的人的列表
	def get_idollist(auth,reqnum,startindex,install)
		MultiJson.decode(open(GETIDOLLISTURL + auth + '&reqnum=' + reqnum + '&startindex=' + startindex + '&install=' + install))
	end

	#收听腾讯微博上的用户
	def add_idol(auth,name)
		MultiJson.decode(post_comm(ADDIDOLURL,URI.escape(auth + '&' + name)))
	end

	#取消收听腾讯微博上的用户
	def del_idol(auth,name)
		MultiJson.decode(post_comm(DELIDOLURL,URI.escape(auth + '&' + name)))	
	end

end