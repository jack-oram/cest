require 'sinatra'
require "sinatra/reloader" if development?
require "active_record"
require "mysql2"

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "127.0.0.1",
  :username => "jack",
  :password => "scooter",
  :database => "cest"
)

class User < ActiveRecord::Base
end

ActiveRecord::Migration.create_table :users do |t|
  t.string :first_name
  t.string :last_name
  t.string :email
  t.string :password
end

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