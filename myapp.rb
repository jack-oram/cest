require 'sinatra'

get '/' do
  erb :index, :layout => :layout
end


get '/register' do
  erb :register, :layout => :layout
end


post '/register' do
  @post = params
  "hello #{@post}"
end