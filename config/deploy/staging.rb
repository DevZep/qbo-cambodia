require 'dotenv'
Dotenv.load

set :stage, :staging
set :repo_url, "git@github.com:rotati/#{fetch(:application)}.git"
server 'qbo-cambodia.rotati.com', user: 'deployer', roles: %w{app web db}
