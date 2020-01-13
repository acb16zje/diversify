# frozen_string_literal: true

namespace :dev do
  desc 'Start development server'
  task server: %i[clean environment] do
    system 'bundle check'
    system 'yarn'

    if ActiveRecord::Base.connection.migration_context.needs_migration?
      system 'db:migrate'
    end

    system 'rails server -b 0.0.0.0 -p 3000 -e development'
  end

  desc 'Remove log/ and tmp/'
  task clean: :environment do
    system 'rm -rf log/ tmp/'
  end
end
