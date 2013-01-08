configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  set :haml, :layout => :application
end

get '/' do
  haml 'Sinatra app skeleton w/ Twitter Bootstrap, Haml and jQuery'
end
