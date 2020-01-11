source 'https://rubygems.org'

source 'https://gems.shefcompsci.org.uk' do
  gem 'airbrake'
  gem 'epi_deploy', group: :development
end

gem 'activerecord-session_store'
gem 'bootsnap'
gem 'puma'
gem 'rails'
gem 'responders'
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'

gem 'pg'

gem 'haml-rails'

gem 'draper'
gem 'ransack', github: 'activerecord-hackery/ransack'

gem 'pagy'

gem 'cancancan'
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'devise_ldap_authenticatable'
gem 'omniauth-google-oauth2'
gem 'dotenv-rails', groups: [:development, :test]

gem 'daemons'
gem 'delayed-plugins-airbrake'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever'

gem 'ahoy_matey'
gem 'chartkick'
gem 'geocoder'
gem 'groupdate'

# CSS styles in action mailer
gem 'premailer-rails'

group :development, :test do
  gem 'byebug'

  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}", branch: 'master'
  end
end

group :development do
  gem 'listen'
  gem 'web-console'

  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

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
