default['rails-lastmile']['app_dir'] = "/vagrant"
default['rails-lastmile']['ruby_version'] = "1.9.3-p385"

# when true, we reset the db using rake db:drop and rake db:setup
default['rails-lastmile']['reset_db'] = false

default['rails-lastmile']['environment'] = 'development'

default['rails-lastmile']['prep_db_with'] = 'db:migrate'

node.default[:unicorn][:worker_timeout] = 30
node.default[:unicorn][:preload_app] = true
node.default[:unicorn][:worker_processes] = 2
node.default[:unicorn][:listen] = '/tmp/unicorn.todo.sock'
node.default[:unicorn][:pid] = '/var/run/unicorn/master.pid'
node.default[:unicorn][:stdout_path] = '/var/log/unicorn.log'
node.default[:unicorn][:stderr_path] = '/var/log/unicorn.log'
node.set[:unicorn][:options] = { :backlog => 100 }
