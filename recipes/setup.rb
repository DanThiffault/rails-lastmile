#
# Cookbook Name:: rails-bootstrap
# Recipe:: setup
#
# Copyright 2012, 119 Labs LLC
#
# All rights reserved - Do Not Redistribute
#
class Chef::Recipe
    # mix in recipe helpers
    include Chef::RubyBuild::RecipeHelpers
end

node['rbenv']['rubies'] = [ node['rails-lastmile']['ruby_version'] ]

include_recipe "apt"
package "build-essential"
include_recipe "ruby_build"

include_recipe "rbenv::system"
include_recipe "rbenv::vagrant"

rbenv_global node['rails-lastmile']['ruby_version']
rbenv_gem "bundler"
rbenv_gem "rails"

