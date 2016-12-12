class Qbo::Base
  attr_reader :credential
  attr_reader :record

  def service
    service_class.new(access_token: auth, realm_id: credential.company_id)
  end

  def method_missing(method, *args)
    record.send(method, *args)
  end

  private

  def auth
    OAuth::AccessToken.new(QB_OAUTH_CONSUMER, credential.access_token, credential.access_secret)
  end

  def service_class

  end
end
