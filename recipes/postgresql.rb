#
# Cookbook Name:: rails-lastmile
# Recipe:: postgresql
#
# Copyright 2013, Nilesh at FungibleClouds.com
#
# See license.txt for details
#

include_recipe "database::postgresql"

# Helper variables
dbname = node['rails-lastmile']['postgresql']['dbname']
dbuser = node['rails-lastmile']['postgresql']['username']
dbpass = node['rails-lastmile']['postgresql']['password']
dbhost = node['rails-lastmile']['postgresql']['host']

dbconn = {
  :host => dbhost,
  :port => node['postgresql']['config']['port'],
  :username => "postgres",
  :password => node["postgresql"]["password"]["postgres"]
}

database dbname do
  connection dbconn
  provider Chef::Provider::Database::Postgresql
  action :create
end

# Create a user that the agent will use
database_user dbuser do
  connection dbconn
  password dbpass
  database_name dbname
  provider Chef::Provider::Database::PostgresqlUser
  action :create
end

# grant all privileges on all tables in chosen dbname
database_user dbuser do
  connection dbconn
  database_name dbname
  privileges [:all]
  action :grant
end
