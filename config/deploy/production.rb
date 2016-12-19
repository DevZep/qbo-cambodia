set :stage, :production
server 'qbocambodia.com', user: 'deployer', roles: %w{app web db}
