require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do

  @Meetups = Meetup.all.order(:name)

  erb :index
end

post '/' do

  authenticate!

@name = params['name'].capitalize
@description = params['description']
@location = params['location']

  begin
    m = Meetup.new(name: @name, description: @description,location: @location)
    if m.save!
      flash[:notice] = 'You have created a new meetup! In space!'
      redirect '/'
    end

  rescue
    flash[:notice] = 'That meetup already exists!'
  end

redirect '/'

end

get '/meetup/:id' do

  @id = Meetup.select("id")
  @id = params[:id]
  @meetup = Meetup.find(@id)

  @attendees = @meetup.users

  erb :'meetup/id'
end

post '/meetup/:id' do
  authenticate!
  @id=params[:id]
  @user = current_user
  begin
  Attendee.create(user_id: @user.id, meetup_id: @id)
  flash[:notice] = 'You are signed up for the meetup! In space!'
  redirect "/meetup/#{@id}"
  rescue
    flash[:notice] = 'You have already signed up for the meetup! In space!'
  end

redirect "/meetup/#{@id}"
end

post '/leave/:id' do
  authenticate!
  @id=params[:id]
  @user = current_user

    Attendee.destroy_all(:user_id => @user.id, :meetup_id => @id)
    flash[:notice] = 'You have left the meetup! In space!'
    redirect "/meetup/#{@id}"

end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
