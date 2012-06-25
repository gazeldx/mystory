# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cms::Application.initialize!

DOMAIN_NAME = "mystory.cc"
SITE_URL = "http://" + DOMAIN_NAME
#DOMAIN_NAME = "mystory2.cc"
#SITE_URL = "http://" + DOMAIN_NAME + ":8080"

S_SIZE=139
D_SIZE=200
#in app/uploaders I can't use these constants.I don't know why.
USER_THUMB_SIZE=48
USER_BIGPIC_SIZE=180
PHOTO_MTHUMB_SIZE=120
PHOTO_COVER_SIZE=170
PHOTO_SQUARE_SIZE=115