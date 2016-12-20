set :stage, :production
set :branch, 'stable'
set :repo_url, "git@github.com:rotati/#{fetch(:application)}.git"

server 'qbocambodia.com', user: 'deployer', roles: %w{app web db}
