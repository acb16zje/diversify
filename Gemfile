# frozen_string_literal: true

source 'https://rubygems.org'

source 'https://gems.shefcompsci.org.uk' do
  gem 'airbrake'
  gem 'epi_deploy', group: :development
end

# Rails core
gem 'rails'
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'

gem 'bootsnap'

# Puma server
gem 'puma'

# Responders respond_to and respond_with
gem 'responders'

# PostgreSQL database
gem 'pg'

gem 'activerecord-session_store'

# Authentication libraries
gem 'cancancan'
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'devise_ldap_authenticatable'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

gem 'daemons'
gem 'delayed-plugins-airbrake'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever'

# Decorators
gem 'draper'

# HAML
gem 'hamlit'

# Pagination
gem 'pagy'

# Advance search forms
gem 'ransack', github: 'activerecord-hackery/ransack'

# Metrics Charts
gem 'ahoy_matey'
gem 'chartkick'
gem 'geocoder'
gem 'groupdate'

# CSS styles in action mailer
gem 'premailer-rails'

group :development, :test do
  gem 'byebug'

  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}"
  end
end

group :development do
  gem 'listen'

  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  # Code Style
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  gem 'annotate'
  gem 'eventmachine'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webdrivers'
end
