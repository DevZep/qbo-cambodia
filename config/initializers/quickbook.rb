::QB_OAUTH_CONSUMER = OAuth::Consumer.new(ENV['QBO_OAUTH_CONSUMER_KEY'], ENV['QBO_OAUTH_CONSUMER_SECRET'], {
    site: 'https://oauth.intuit.com',
    request_token_path: '/oauth/v1/get_request_token',
    authorize_url: 'https://appcenter.intuit.com/Connect/Begin',
    access_token_path: '/oauth/v1/get_access_token'
})
