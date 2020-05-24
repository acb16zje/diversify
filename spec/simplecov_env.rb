# frozen_string_literal: true

require 'simplecov'
require 'active_support/core_ext/numeric/time'

module SimpleCovEnv
  class << self
    def start
      configure_profile
      configure_job

      SimpleCov.start
    end

    def configure_job
      SimpleCov.configure do
        if ENV['GITLAB_CI']
          job_name = ENV['CI_JOB_NAME']
          coverage_dir "coverage/#{job_name}"
          command_name job_name
          SimpleCov.at_exit { SimpleCov.result }
        end
      end
    end

    def configure_profile
      SimpleCov.configure do
        load_profile 'test_frameworks'

        add_filter %r{^/config/}
        add_filter %r{^/db/}
        add_filter 'vendor/'
        add_filter 'app/jobs'

        add_group 'Controllers', 'app/controllers'
        add_group 'Models', 'app/models'
        add_group 'Mailers', 'app/mailers'
        add_group 'Helpers', 'app/helpers'
        add_group 'Policies', 'app/policies'
        add_group 'Serializers', 'app/serializers'
        add_group 'Validators',  'app/validators'

        track_files '{app}/**/*.rb'

        merge_timeout 365.days
      end
    end
  end
end
