::QB_OAUTH2 = OAuth2::Client.new(ENV['QBO_CLIENT_ID'], ENV['QBO_CLIENT_SECRET'], {
  site: "https://appcenter.intuit.com/connect/oauth2",
  authorize_url: "https://appcenter.intuit.com/connect/oauth2",
  token_url: "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
})
