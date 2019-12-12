desc 'Deploy to epiDeploy.'
task :deploy do
  sh 'eval `ssh-agent -s`'
  sh 'ssh-add'
  sh 'bundle exec ed release -d demo'
end
