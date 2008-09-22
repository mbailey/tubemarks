# require 'deprec'

# # uses capistrano-ext gem to load stage specific 
# # config from deploy/staging.rb and deploy/production.rb
# set :default_stage, 'staging'
# require 'capistrano/ext/multistage'

set :domain, "tubemarks.deprecated.org"
set :application, "tubemarks"
set :repository,  "svn+ssh://scm.deprecated.org/var/www/apps/tubemarks/repos"
set :gems_for_project, %w(has_finder will_paginate youtube mysql sqlite3-ruby) # list of gems to be installed

set :mongrel_port, 8010
set :mongrel_servers, 1

# Update these if you're not running everything on one host.
role :app, domain
role :web, domain
role :db,  domain, :primary => true
# role :scm, 'scm.deprecated.org' # used by deprec if you want to install subversion

# If you aren't deploying to /var/www/apps/#{application} on the target
# servers (which is the deprec default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion


after :deploy do
  run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.mongrel.restart
  end
end
