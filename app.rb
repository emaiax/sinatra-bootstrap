configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  set :haml, :layout => :application
  use Rack::Session::Cookie, :key => 'rack.session', :secret => 'change_me', :expire_after => 2592000 # In seconds
end

helpers do
  def user_signed_in?
    not session[:identity].nil?
  end

  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = "Sorry guacamole, you need to be logged in to visit #{request.path}!"
    halt haml(:login)
  end
end

get '/' do
  haml '<p>Can you handle a <a href="/secure/place">secret</a>?</p><p class="muted">Sinatra app skeleton w/ Twitter Bootstrap, Haml and jQuery</p>'
end

get '/login' do 
  haml :login
end

post '/login/attempt' do
  if params['username'].empty?
    @error = 'Sorry guacamole, you need to use a valid username!'
    halt haml(:login)
  else
    session[:identity] = params['username']
    where_user_came_from = session[:previous_url] || '/'
    redirect to where_user_came_from 
  end
end

get '/logout' do
  session.delete(:identity)
  haml "<div class='alert alert-message'>Logged out</div>"
end


get '/secure/place' do
  haml "This is a secret place that only <b>#{session[:identity]}</b> has access to!"
end
