require 'dotenv'
Dotenv.load

set :stage, :staging
server 'qbo-cambodia.rotati.com', user: 'deployer', roles: %w{app web db}
