class BaseService
  attr_reader :service, :qbo_credential

  def initialize(qbo_credential)
    auth            = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, qbo_credential.access_token, qbo_credential.access_secret)
    @qbo_credential = qbo_credential
    @service        = service_class.new(access_token: auth, realm_id: qbo_credential.company_id)
  end

  def get_all_invoices
    raise NotImplementedError
  end

  def find_by_ids
    raise NotImplementedError
  end

  def find
    raise NotImplementedError
  end

  private

  def service_class
    raise NotImplementedError
  end
end
