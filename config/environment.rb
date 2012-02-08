# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cms::Application.initialize!

DOMAIN_NAME = "mystory.cc"
SITE_URL = "http://" + DOMAIN_NAME + ":8080"

#Slim::Engine.set_default_options :sections => true