require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  #facebook_options = {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}, :scope => ''}

  #provider :twitter, 'KEY', 'SECRET'
  #provider :facebook, 'APP_ID', 'APP_SECRET', facebook_options
  #provider :linked_in, 'KEY', 'SECRET'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"

end