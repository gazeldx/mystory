# Be sure to restart your server when you modify this file.
# share session for subdomain.
Cms::Application.config.session_store :cookie_store, :key => '_mystory_session', :domain => :all
#Cms::Application.config.session_store :cookie_store, :key => '_mystory2_session', :domain => "mystory2.cc"
#Cms::Application.config.session_store :cookie_store, :key => '_cy21_session', :domain => "cy21.org"
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#Cms::Application.config.session_store :active_record_store
