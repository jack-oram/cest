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

  has_many :trades, dependent: :destroy

end

class Trade < ActiveRecord::Base
  validates :product_name, :description, :condition_part, presence: true
  
  belongs_to :user

end

# ActiveRecord::Migration.create_table :users do |t|
#   t.string :first_name
#   t.string :last_name
#   t.string :email
#   t.string :password
# end

enable :sessions

helpers do
  def image_for_trade(trade)
   # .. write code here that looks for files in './public/ that match "#{trade.id}-"
   filename = "./test2.jpg"
    return filename
  end
end

def get_current_user()
  @user = User.find_by(id: session[:id])
end

get '/' do
  puts "Session #{session[:id]}"
  get_current_user()
  @trades = Trade.all
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

get '/addtrade' do
  get_current_user()
  @trade = Trade.new
  erb :addtrade, :layout => :layout
end

post '/addtrade' do
  get_current_user()
  product_name = params[:product_name]
  description = params[:description]
  condition_part = params[:condition_part]

  @trade = @user.trades.create(product_name: product_name, 
                                description: description, 
                                condition_part: condition_part)
  
  
  if @trade.valid? 

    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
  
    File.open("./public/#{@trade.id}-#{@filename}", 'wb') do |f|
      f.write(file.read)
    end  

    "saved ok"
    redirect to('/')
  else
    erb :addtrade, :layout => :layout
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