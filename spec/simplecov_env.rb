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
        load_profile 'rails'

        add_filter 'vendor/'
        add_filter 'app/controllers/reviews_controller.rb'
        add_filter 'app/controllers/tasks_controller.rb'
        add_filter 'app/controllers/teams_controller.rb'

        add_filter 'app/jobs'

        add_filter 'app/models/category.rb'
        add_filter 'app/models/issue.rb'
        add_filter 'app/models/license.rb'
        add_filter 'app/models/personality.rb'
        add_filter 'app/models/preference.rb'
        add_filter 'app/models/review.rb'
        add_filter 'app/models/skill.rb'
        add_filter 'app/models/skill_level.rb'
        add_filter 'app/models/subscription_plan.rb'
        add_filter 'app/models/task.rb'
        add_filter 'app/models/team.rb'
        add_filter 'app/models/user_personality.rb'

        add_filter 'lib/'

        add_group 'Policies', 'app/policies'
        add_group 'Validators',  'app/validators'

        merge_timeout 365.days
      end
    end

  end
end
