# frozen_string_literal: true

require_relative 'boot'

# Based on https://github.com/rails/rails/blob/v6.0.2.1/railties/lib/rails/all.rb
# Only load the railties we need instead of loading everything
require 'rails'

require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'action_text/engine'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Diversify
  class Application < Rails::Application
    # Send queued jobs to delayed_job
    config.active_job.queue_adapter = :delayed_job

    # This points to our own routes middleware to handle exceptions
    config.exceptions_app = routes

    config.generators do |g|
      g.helper false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.test_framework :rspec,
                       fixture: true,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       view_specs: false,
                       integration_tool: false
    end

    config.action_mailer.logger = nil
    config.action_mailer.smtp_settings = {
      address: 'mailhost.shef.ac.uk',
      port: 587,
      enable_starttls_auto: true,
      openssl_verify_mode: OpenSSL::SSL::VERIFY_PEER,
      openssl_verify_depth: 3,
      ca_file: '/etc/ssl/certs/ca-certificates.crt',
      domain: 'team07.demo1.genesys.shefcompsci.org.uk'
    }

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
