Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cms::Application.initialize!

DOMAINS = [Settings.domain]

if Settings[:qq]
  APPID = Settings.qq.appid.to_s
  APPKEY = Settings.qq.appkey
end

#QQ and weibo connect
REDURL = "&redirect_uri=#{Settings.domain}/qq_callback"
WeiboOAuth2::Config.redirect_uri = "http://#{Settings.domain}/weibo_callback"

YUN_IMAGES = Settings[:upyun] ? "http://#{Settings.upyun.bucket_domain}/images/" : "/images/"

S_SIZE=126
D_SIZE=200
#in app/uploaders I can't use these constants.I don't know why.
USER_THUMB_SIZE=48
USER_BIGPIC_SIZE=180
PHOTO_MTHUMB_SIZE=120
PHOTO_COVER_SIZE=170
PHOTO_SQUARE_SIZE=115

MIN_COLLEGE_MEMBER=3

#The meaning of some Tables Column.
GROUPS_STYPE_SCHOOL = 1
GROUPS_STYPE_SOCIETY = 2
MESSAGES_STYPE_GROUP_INVITATION = 10
GADS_STYPE_TOP = 1
GADS_STYPE_SIDE = 2