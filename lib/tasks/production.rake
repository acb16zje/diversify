# frozen_string_literal: true

namespace :production do
  desc 'Prepare the deployment requirements'
  task prepare: :environment do
    # Check ssh-agent, and do ssh-add
    system ". #{Rails.root.join('lib/scripts/ssh-agent.sh')}"

    # Remove old webpack output
    Rake::Task['webpacker:clobber'].invoke

    # Compile webpack for production
    Rake::Task['webpacker:compile'].invoke
  end

  desc 'Deploy to epiDeploy.'
  task deploy: [:prepare] do
    system 'bundle exec ed release -d demo'
  end
end
