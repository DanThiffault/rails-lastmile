#
# Cookbook Name:: rails-bootstrap
# Recipe:: default
#
# Copyright 2012, 119 Labs LLC
#
# All rights reserved - Do Not Redistribute
#
class Chef::Recipe
    # mix in recipe helpers
    include Chef::RubyBuild::RecipeHelpers
end

app_dir = node['rails-lastmile']['app_dir']
#app_dir = '/vagrant/'

rbenv_ruby "1.9.2-p290"
rbenv_global "1.9.2-p290"

rbenv_gem "bundler"
rbenv_gem "rails"

file "/var/run/unicorn.pid" do
  owner "root"
  group "root"
  mode "666"
  action :create_if_missing
end

file "/var/log/unicorn.log" do
  owner "root"
  group "root"
  mode "666"
  action :create_if_missing
end

template "/etc/unicorn.cfg" do
  owner "root"
  group "root"
  mode "644"
  source "unicorn.erb"
  variables( :app_dir => app_dir)
end

rbenv_script "run-rails" do
  code <<-EOH
    bundle install
    bundle exec unicorn -c /etc/unicorn.cfg -D
  EOH
end

template "/etc/nginx/sites-enabled/default" do
  owner "root"
  group "root"
  mode "644"
  source "ngnix.erb"
  variables( :static_root => "#{app_dir}/public")
  notifies :restart, "service[ngnix]"
end

service "unicorn"
service "ngnix"
