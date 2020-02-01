# frozen_string_literal: true

require './spec/simplecov_env'
SimpleCovEnv.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'action_policy/rspec/dsl'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# If the test database needs migrating, load in the current schema
if ActiveRecord::Base.connection.migration_context.needs_migration?
  puts('Loading schema into test database...')
  ActiveRecord::Tasks::DatabaseTasks.load_schema_current
end
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # See https://relishapp.com/rspec/rspec-rails/docs/transactions
  config.use_transactional_fixtures = true

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
  config.include Capybara::DSL # Let's us use the capybara stuff in our specs
  config.include Warden::Test::Helpers
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::IntegrationHelpers
  config.include Devise::Test::ControllerHelpers, type: :controller

  # Include custom helpers
  config.include NewsletterHelper

  config.after { Warden.test_reset! }

  config.before(:example, :mailer) { ActionMailer::Base.deliveries.clear }

  # Run headless chrome for system test
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  config.before(:each, type: :system, js: true) do
    driven_by(:selenium_chrome_headless)
  end
end

Webdrivers.install_dir = Rails.root.join('vendor', 'webdrivers')
Webdrivers.cache_time = 86_400

require 'selenium/webdriver'
Capybara.register_driver :chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('--headless') unless ENV['SHOW_CHROME']
  chrome_options.add_argument('--no-sandbox')
  chrome_options.add_argument('--disable-gpu')
  chrome_options.add_argument('--disable-dev-shm-usage')
  chrome_options.add_argument('--disable-infobars')
  chrome_options.add_argument('--disable-extensions')
  chrome_options.add_argument('--disable-popup-blocking')
  chrome_options.add_argument('--window-size=1920,4320')

  # LTSP has multiple versions of Chrome installed, so prefer Chromium
  LTSP_BIN = '/usr/bin/chromium-browser'
  chrome_options.binary = LTSP_BIN if File.exist?(LTSP_BIN)

  # Rails takes a little time to start, so wait ~2 mins before failing
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120 # seconds

  Capybara::Selenium::Driver.new app, browser: :chrome, options: chrome_options, http_client: client
end

Capybara.configure do |config|
  config.asset_host = 'http://localhost:3000'
  config.javascript_driver = :chrome
  config.match = :prefer_exact
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
