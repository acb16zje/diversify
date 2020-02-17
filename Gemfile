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

# Enum column support for Rails schema
gem 'activerecord-pg_enum'

# Active Storage
gem 'active_storage_validations'

# Avatar
gem 'gravatar_image_tag'
gem 'image_processing'

# Authentication libraries
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Authorization, see https://github.com/palkan/action_policy
gem 'action_policy'

gem 'daemons'
gem 'delayed-plugins-airbrake'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever'

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
  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  # Code Style
  gem 'haml_lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  gem 'annotate'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webdrivers'
end
