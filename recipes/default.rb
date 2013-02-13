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

include_recipe "rails-lastmile::setup"

include_recipe "nginx"
include_recipe "unicorn"

directory "/var/run/unicorn" do
  owner "root"
  group "root"
  mode "777"
  action :create
end

file "/var/run/unicorn/master.pid" do
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
  rbenv_version "1.9.3-p286"
  cwd app_dir

  code <<-EOH
    bundle install
    bundle exec rake db:migrate
    ps -p `cat /var/run/unicorn/master.pid` &>/dev/null || bundle exec unicorn -c /etc/unicorn.cfg -D
  EOH
end

template "/etc/nginx/sites-enabled/default" do
  owner "root"
  group "root"
  mode "644"
  source "nginx.erb"
  variables( :static_root => "#{app_dir}/public")
  notifies :restart, "service[nginx]"
end

service "unicorn"
service "nginx"
