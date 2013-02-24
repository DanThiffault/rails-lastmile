#
# Cookbook Name:: rails-lastmile
# Recipe:: postgresql
#
# Copyright 2013, Nilesh at FungibleClouds.com
#
# See license.txt for details
#

include_recipe "database"

#node.default["postgresql"]["password"]["postgres"] = "szstpq13"

dbconn = {
  :host => "localhost",
  :port => node['postgresql']['config']['port'],
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

database node['rails-lastmile']['postgresql']['dbname'] do
  connection dbconn
  provider Chef::Provider::Database::Postgresql
  action :create
end

# grant all privileges on all tables in chosen dbname
postgresql_database_user node["rails-lastmile"]["postgresql"]["username"] do
  connection dbconn
  database_name node['rails-lastmile']['postgresql']['dbname']
  privileges [:all]
  action :grant
end
