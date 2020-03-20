# frozen_string_literal: true

source 'https://rubygems.org'

source 'https://gems.shefcompsci.org.uk' do
  gem 'airbrake'
  gem 'epi_deploy', group: :development
end

# Rails core
gem 'rails', '>= 6.0.2.2'
gem 'webpacker', '>= 4.2.2'

gem 'bootsnap'

# Puma server
gem 'puma'

# Responders respond_to and respond_with
gem 'responders', '>= 3.0.0'

# PostgreSQL database
gem 'pg'

# Enum column support for Rails schema
gem 'activerecord-pg_enum'

# Active Storage
gem 'active_storage_validations', '>= 0.8.7'

# Avatar
gem 'gravatar_image_tag'
gem 'image_processing'

# Authentication libraries
gem 'devise', '>= 4.7.1'
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

# Metrics Charts
gem 'ahoy_matey'
gem 'chartkick'
gem 'geocoder'
gem 'groupdate'

# CSS styles in action mailer
gem 'premailer-rails', '>= 1.10.3'

group :development, :test do
  gem 'byebug'

  # https://github.com/rspec/rspec-rails/pull/2117
  gem 'rspec-rails', '~> 4.0.0.beta'
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
  gem 'factory_bot_rails', '>= 5.1.1'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webdrivers'
end
