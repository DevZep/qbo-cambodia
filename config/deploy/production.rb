set :stage, :production
set :branch, 'stable'

server 'qbocambodia.com', user: 'deployer', roles: %w{app web db}
