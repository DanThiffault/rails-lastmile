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

node['rbenv']['rubies'] = [ "1.9.3-p286"]

include_recipe "apt"
package "build-essential"
include_recipe "ruby_build"

include_recipe "rbenv::system"
include_recipe "rbenv::vagrant"

rbenv_global "1.9.3-p286"
rbenv_gem "bundler"
rbenv_gem "rails"

