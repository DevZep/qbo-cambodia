lock '3.7.0'

set :application, "qbo-cambodia"
set :repo_url, "git@github.com:rotati/#{fetch(:application)}.git"

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, "/var/www/#{fetch(:application)}"

set :scm, :git

set :pty, true
set :keep_releases, 5

set :rvm_ruby_version, '2.3.3@qbo-cambodia'
set :rvm_roles, [:app, :web]

set :passenger_restart_with_touch, true

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')
set :linked_files, fetch(:linked_files, []).push('.env')

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  task :cleanup_assets do
    on roles :all do
      execute "cd #{release_path}/ && ~/.rvm/bin/rvm 2.3.3@qbo-cambodia do bundle exec rake assets:clobber RAILS_ENV=#{fetch(:stage)}"
    end
  end

  before :updated, :cleanup_assets
end

require 'appsignal/capistrano'

require 'appsignal/capistrano'

require 'appsignal/capistrano'