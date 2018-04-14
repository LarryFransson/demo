Padrino.use Rack::Session::Cookie, :secret => "This is some secret key"

Padrino.configure_apps do
  # enable :sessions
  set :session_secret, 'eb0b409f98fd3cfbee4bd4895be8d79758d54154ad377ec5600461ec75de3b6b'
  set :protection, :except => :path_traversal
  set :protect_from_csrf, true
end


# Mounts the core application for this project

Padrino.mount('Demo::Auth', :app_file => Padrino.root('auth/app.rb')).to('/auth')
Padrino.mount('Demo::App', :app_file => Padrino.root('app/app.rb')).to('/')
