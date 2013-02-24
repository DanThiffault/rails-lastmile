#
# Cookbook Name:: rails-lastmile
# Recipe:: postgresql
#
# Copyright 2013, Nilesh at FungibleClouds.com
#
# See license.txt for details
#

include_recipe "database"

chef_gem 'pg'

dbconn = {
  :host => "localhost",
  :port => node["postgresql"]["port"],
  :username => "postgres",
  :password => node["postgresql"]["password"]["postgres"]
}

# Create a user that the agent will use
database_user node["rails-lastmile"]["postgresql"]["username"] do
  connection dbconn
  password node["rails-lastmile"]["postgresql"]["password"]
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

