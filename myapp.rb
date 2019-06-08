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

enable :sessions

get '/' do
  puts "Session #{session[:id]}"
  @user = User.find_by(id: session[:id])
  erb :index, :layout => :layout
end

get '/login' do
  @user = User.new
  erb :login, :layout => :layout
end

post '/login' do
  email = params[:email]
  password = params[:password]
  @user = User.find_by(email: email, password: password)
  if @user
    "welcome @user"
    session[:id]=@user.id
    redirect to('/')
  else
    @user = User.new
    @user.errors[:base] << "invalid email or password"
    erb :login, :layout => :layout
  end
end

get '/register' do
  @user = User.new
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
    session[:id]=@user.id
  else
    erb :register, :layout => :layout
  end
end