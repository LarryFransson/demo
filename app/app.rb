module Demo
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions

    get :index do
      logger.info 'INDEX: ' + env['warden'].user.inspect
      env['warden'].authenticate!
      "PROTECTED CONTENT HERE: " + env['warden'].user.inspect
    end

  end
end
