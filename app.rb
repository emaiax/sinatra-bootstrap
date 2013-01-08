configure do
  set :haml, :layout => :application
end

get '/' do
  haml 'Sinatra app skeleton w/ Twitter Bootstrap, Haml and jQuery'
end
