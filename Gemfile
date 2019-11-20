source "https://rubygems.org"
ruby '2.6.2'
source "https://gems.shefcompsci.org.uk" do
  gem 'airbrake'
  gem 'capybara-select2', group: :test
  gem 'epi_deploy', group: :development
  gem 'epi_js'
  gem 'rubycas-client'
end

gem 'activerecord-session_store'
gem 'bootsnap'
gem 'rails'
gem 'responders'
gem 'thin'

gem 'pg'

gem 'haml-rails'
gem 'sassc-rails'
gem 'uglifier'

gem 'bulma-rails', "~> 0.8.0"
gem 'jquery-rails'

gem 'draper'
gem 'ransack'
gem 'simple_form'

gem 'will_paginate'

gem 'cancancan'
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'devise_ldap_authenticatable'

gem 'daemons'
gem 'delayed-plugins-airbrake'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever'

gem 'ahoy_matey'
gem 'chartkick'
gem 'groupdate'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'web-console'

  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  gem 'annotate'
  gem 'eventmachine'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'rspec-instafail', require: false
  gem 'shoulda-matchers'
  gem 'webdrivers'

  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
end
