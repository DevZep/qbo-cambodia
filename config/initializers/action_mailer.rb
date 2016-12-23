QboCambodia::Application.config.action_mailer.default_url_options = { host: ENV['HOST'] }

if Rails.env.production?
  QboCambodia::Application.config.action_mailer.delivery_method = :smtp
  QboCambodia::Application.config.action_mailer.smtp_settings = {
    address:               'email-smtp.us-east-1.amazonaws.com',
    authentication:        :login,
    user_name:             ENV['AWS_SES_USER_NAME'],
    password:              ENV['AWS_SES_PASSWORD'],
    from:                  ENV['SENDER_EMAIL'],
    enable_starttls_auto:  true,
    port:                  465,
    openssl_verify_mode:   OpenSSL::SSL::VERIFY_NONE,
    ssl:                   true,
    tls:                   true
  }
end
