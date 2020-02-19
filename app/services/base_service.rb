class BaseService
  attr_reader :service, :qbo_credential

  def initialize(qbo_credential)
    @qbo_credential = qbo_credential
    @qbo_credential.refresh_tokens

    access_token    = OAuth2::AccessToken.new(QB_OAUTH2, qbo_credential.oauth2_access_token, refresh_token: qbo_credential.oauth2_refresh_token)
    @service        = service_class.new(access_token: access_token, realm_id: qbo_credential.company_id)
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
