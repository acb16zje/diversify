# frozen_string_literal: true

require 'simplecov'
require 'active_support/core_ext/numeric/time'

module SimpleCovEnv
  class << self

    def start
      SimpleCov.start { configure_profile }
    end

    def configure_profile
      SimpleCov.configure do
        load_profile 'rails'

        if ENV['CI_JOB_NAME']
          job_name = ENV['CI_JOB_NAME']
                       .downcase
                       .gsub(/[^a-z0-9]/, '-')[0..62]
                       .gsub(/(\A-+|-+\z)/, '')
          coverage_dir "coverage/#{job_name}"
          command_name job_name
        end

        if ENV['CI']
          SimpleCov.at_exit do
            # In CI environment don't generate formatted reports
            # Only generate .resultset.json
            SimpleCov.result
          end
        end

        add_filter '/vendor/'
        add_filter '/app/controllers/projects_controller.rb'
        add_filter '/app/controllers/reviews_controller.rb'
        add_filter '/app/controllers/tasks_controller.rb'
        add_filter '/app/controllers/teams_controller.rb'

        add_filter '/app/jobs'

        add_filter '/app/models/category.rb'
        add_filter '/app/models/issue.rb'
        add_filter '/app/models/license.rb'
        add_filter '/app/models/personality.rb'
        add_filter '/app/models/preference.rb'
        add_filter '/app/models/project.rb'
        add_filter '/app/models/review.rb'
        add_filter '/app/models/skill.rb'
        add_filter '/app/models/skill_level.rb'
        add_filter '/app/models/subscription_plan.rb'
        add_filter '/app/models/task.rb'
        add_filter '/app/models/team.rb'
        add_filter '/app/models/user_personality.rb'

        add_group 'Decorators',  'app/decorators'
        add_group 'Validators',  'app/validators'

        # 10 days
        merge_timeout 365.days
      end
    end

  end
end
