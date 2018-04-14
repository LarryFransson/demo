module Demo
  class Auth < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions

    set :protection, false
    set :protect_from_csrf, false
        
    Padrino.use Warden::Manager do |config|
      # Tell Warden how to save our User info into a session.
      # Sessions can only take strings, not Ruby code, we'll store
      # the User's `id`
      config.serialize_into_session{|user| user[:email] }
      # Now tell Warden how to take what we've stored in the session
      # and get a User from that information.
      config.serialize_from_session{|email| User.new(email: email) }
      config.default_strategies :password
      # config.scope_defaults :default,
      #   # "strategies" is an array of named methods with which to
      #   # attempt authentication. We have to define this later.
      #   strategies: [:password],
      #   # The action is a route to send the user to when
      #   # warden.authenticate! returns a false answer. We'll show
      #   # this route below.
      #   action: 'unauthenticated'
      # When a user tries to log in and cannot, this specifies the
      # app to send the user to.
      config.failure_app = Demo::Auth

    end

    Warden::Manager.before_failure do |env,opts|
      # Because authentication failure can happen on any request but
      # we handle it only under "post '/auth/unauthenticated'", we need
      # to change request to POST
      env['REQUEST_METHOD'] = 'POST'
      # And we need to do the following to work with  Rack::MethodOverride
      env.each do |key, value|
        env[key]['_method'] = 'post' if key == 'rack.request.form_hash'
      end
    end

    Warden::Manager.after_set_user do |user, auth, opts|
      logger.info 'USER SET: ' + user.inspect
    end

    Warden::Manager.after_authentication do |user,auth,opts|
      logger.info "AFTER AUTH: " + user.inspect
      # user.update_attribute(:last_login, DateTime.now)
    end

    Warden::Manager.before_logout do |user,auth,opts|
      logger.info 'LOGGING OUT' + user.inspect
    end

    Warden::Strategies.add(:password) do
      def valid?
        # logger.info 'CHECKING VALIDITY'
        params['email']
      end

      def authenticate!
        user = User.new(email: params['email'])
        # logger.info 'USER IN AUTHENTICATE!: ' + user.to_s
        if user.nil?
          throw(:warden, message: "The username you entered does not exist.")
        elsif User.authenticate(params['email'])
          success!(user)
        else
          throw(:warden, message: "The username and password combination ")
        end
      end

    end


    get :login do
      render :login
    end

    post :unauthenticated do
      logger.info 'UNAUTHENTICATED: ' + env['warden'].user.inspect
      redirect url_for :login
    end
  end
end
