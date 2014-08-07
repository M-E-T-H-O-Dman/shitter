require "data_mapper"
require './lib/poop' 
require './lib/user'
require './lib/reset_password'
require 'sinatra'
require 'rack-flash'
require 'rest-client'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/shitter_#{env}")
DataMapper.finalize
DataMapper.auto_upgrade!

use Rack::Flash

enable :sessions
set :session_secret, 'super secret'
set :views, './app/views'

get '/' do
  erb :"index"
end

get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  @user = User.new(:email => params[:email], 
              :password => params[:password],
              :password_confirmation => params[:password_confirmation],
              :username => params[:username],
              :name => params[:name])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/poops')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/users/forgottenpassword' do 
    erb :"users/forgottenpassword"
end 

post '/users/recover' do
    @forgetful_user = User.first(email: params[:email])

    if @forgetful_user
    generate_password_token(params[:email])
    flash[:notice] = "We have sent a reset token to #{params[:email]}"
    Reset_password.send(@forgetful_user)
    redirect to ('/')

    else 
    flash[:notice] = "I'm sorry, we could not find that email address in our database"
    end
end  

get '/users/set_new_password/:token' do 
    @token = params[:token]
    user = User.first(:password_token => params[:token])
    erb :"users/set_new_password"
end  

post '/users/set_new_password' do  
    user = User.first(:password_token => params[:token])
    user.password = params[:"New password"]
    redirect to ('/')
end    



def generate_password_token(email)
    user = User.first(:email => email)
    # avoid having to memorise ascii codes
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
end  

delete '/sessions' do 
 flash[:notice] = "Good bye!"
 session[:user_id] = nil
 redirect to('/')
end

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password is incorrect"]
    erb :"sessions/new"
  end
end

get '/poops' do
  erb :"poops"
end  

helpers do

  def current_user    
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
  end

end