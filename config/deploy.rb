require 'deprec'
  
set :application, "tubemarks"
set :domain, "www.tubemarks.com"
set :repository,  "git://github.com/#{user}/#{application}.git"

set :database_yml_in_scm, false

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
   
set :ruby_vm_type,      :ree        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :mysql      # :mysql, :postgresql, :sqlite

# set :packages_for_project, %w(libmagick9-dev imagemagick libfreeimage3) # list of packages to be installed
set :gems_for_project, %w(has_finder will_paginate youtube mysql sqlite3-ruby) # list of gems to be installed

# role :app, domain
# role :web, domain
# role :db,  domain, :primary => true

role :app, 'hh.failmode.com'
role :web, 'hh.failmode.com'
role :db,  'db.failmode.com', :primary => true, :no_release => true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end
end

# after :deploy do
#   run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/productio
# n.sqlite3"
# end
