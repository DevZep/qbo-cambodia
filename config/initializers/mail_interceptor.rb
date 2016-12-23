options = { forward_emails_to: 'qbo-cambodia@googlegroups.com' }

if Rails.env.staging?
  interceptor = MailInterceptor::Interceptor.new(options)
  ActionMailer::Base.register_interceptor(interceptor)
end
