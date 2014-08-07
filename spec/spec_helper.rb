require './server'
require 'database_cleaner'
require 'capybara/rspec'
require 'sinatra'

Capybara.app = Sinatra::Application.new

RSpec.configure do |config|
ENV["RACK_ENV"] = 'test' 

end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
  
def sign_in(email, password)
    visit '/sessions/new'
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    click_button 'Sign in'
  end


  def sign_up(email = "alice@example.com", 
              password = "oranges!",
              password_confirmation = "oranges!",
              username = "alice_1",
              name = "Alice")
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    fill_in :username, :with => username
    fill_in :name, :with => name
    click_button "Sign up"
  end
