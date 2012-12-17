Description
===========
Configures a server for rails hosting. Delegates as much as possible to
other cookbooks & ties everything together.


Attributes
==========
app_dir location on remote system where rails project will be found.
Defaults to "/vagrant".

Installation
============

I suggest installing through [librarian-chef](https://github.com/applicationsonline/librarian). Librarian
manages chef recipes analogous to how bundler managers gems. So first install librarian:

```
# Install librarian
gem install librarian

# Add its work directories to your gitignore
echo cookbooks >> .gitignore
echo tmp >> .gitignore

# Create the Librarian config file
librarian-chef init

# Create a spot for vendored cookbooks
mkdir cookbooks-src 

# Clone rails-lastmile into vendored cookbooks
git submodule add git://github.com/DanThiffault/rails-lastmile.git cookbooks-src/rails-lastmile
```

Next setup your Cheffile (think Gemfile) with the following recipes

```ruby
cookbook 'build-essential'

cookbook 'ruby_build',
  :git => 'git://github.com/fnichol/chef-ruby_build.git', :ref => 'v0.6.2'
cookbook 'rbenv',
  :git => 'https://github.com/fnichol/chef-rbenv', :ref => '7d9b66f20d6edb786720b22919fd53e698fce12b'
cookbook 'apt',
  :git => 'https://github.com/opscode-cookbooks/apt'                                                                                                                              
cookbook 'unicorn'
cookbook  'nginx'
cookbook  'runit' 
```

Any time you make changes to your Cheffile be sure to run

```
librarian-chef install
```

Note that you can customize rails-last mile (or any other cookbook you put into cookbooks-src). If you make changes to cookbooks
managed by librarian they will be overwritten.

Usage
=====

The goal of rails-lastmile is to make deployments to different environments as similar as possible. Check the subsections 
below for how to deploy to a particular environment.

Vagrant
-------
Vagrant is the first environment rails-lastmile supports. Firstly you need to install
and setup Vagrant in this project. Make sure to install the lastest virtual box from [here](https://www.virtualbox.org)

```
# Install the gem
gem install vagrant

# Grab the 64-bit base box. This could take a while
vagrant box add precise64 http://files.vagrantup.com/precise64.box

# Make sure you're in the application directory and create a Vagrantfile
vagrant init precise64
```

In order to use with vagrant make a Vagrantfile something like this:

```ruby
 config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks","cookbooks-src"]

    chef.add_recipe "rails-lastmile"
  end
```

Don't forget that you need to have the unicorn gem in your Gemfile.
Last thing to do is boot up the virtual machine. With the command `vagrant up`

This will take a while depending on your internet connection and computer speed. After the command completes you should have a
fully deployed app on your vagrant box.

