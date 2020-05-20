# frozen_string_literal: true

require './spec/simplecov_env'
SimpleCovEnv.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'action_policy/rspec'
require 'action_policy/rspec/dsl'
require 'active_storage_validations/matchers'

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
  config.include Devise::Test::IntegrationHelpers

  # Include custom helpers
  config.include OAuthHelper
  config.include ActiveStorageValidations::Matchers
  config.include UserHelper

  config.after { Warden.test_reset! }

  config.before(:example, :mailer) { ActionMailer::Base.deliveries.clear }

  # Run headless chrome for system test
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  config.before(:each, :js, type: :system) do
    driven_by(:chrome)
  end
end

Webdrivers.install_dir = Rails.root.join('vendor', 'webdrivers')
Webdrivers.cache_time = 86_400

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless') unless ENV['SHOW_CHROME']
  options.add_argument('no-sandbox')
  options.add_argument('disable-gpu')
  options.add_argument('disable-dev-shm-usage')
  options.add_argument('disable-infobars')
  options.add_argument('disable-extensions')
  options.add_argument('disable-popup-blocking')
  options.add_argument('window-size=1366,768')
  options.add_argument("user-data-dir=/tmp/chrome") if ENV['CI']

  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.asset_host = 'http://localhost:3000'
  config.javascript_driver = :chrome
  config.default_max_wait_time = ENV['CI'] ? 60 : 30
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
