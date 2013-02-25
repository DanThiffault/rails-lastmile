#
# Cookbook Name:: rails-bootstrap
# Recipe:: setup
#
# Copyright 2013, 119 Labs LLC
#
# See license.txt for details
#
class Chef::Recipe
    # mix in recipe helpers
    include Chef::RubyBuild::RecipeHelpers
end

node.default['rbenv']['rubies'] = [ node['rails-lastmile']['ruby_version'] ]

include_recipe "apt"
package "build-essential"
include_recipe "ruby_build"

include_recipe "rbenv::system"
include_recipe "rbenv::vagrant"

rbenv_global node['rails-lastmile']['ruby_version']
rbenv_gem "bundler"
rbenv_gem "rails"
