Demo::Auth.controllers :sessions do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  post :create do
    env['warden'].authenticate!
    if env['warden'].authenticated?
      logger.info 'AUTHENTICATED: ' + env['warden'].user.inspect
      # flash[:success] = "You have logged in."
      redirect '/'
    else
      logger.info 'YEAH...THAT DIDN\'T WORK'
      # flash[:error] = "That's not it."
      redirect url_for :login
    end
  end

  
end
