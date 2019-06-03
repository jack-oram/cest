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
  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, :password, presence: true
  validates :terms, acceptance: true
end

# ActiveRecord::Migration.create_table :users do |t|
#   t.string :first_name
#   t.string :last_name
#   t.string :email
#   t.string :password
# end



get '/' do
  erb :index, :layout => :layout
end


get '/register' do
  erb :register, :layout => :layout
end


post '/register' do
  first_name = params[:first_name]
  last_name = params[:last_name]
  email = params[:email]
  password = params[:password]

  puts "SAVE"
  @user = User.new(first_name: first_name, 
                   last_name: last_name, 
                   email: email, 
                   password: password)
  if @user.save
    "saved ok"
  else
    puts @user.inspect
    "errors #{@user}"
  end
end