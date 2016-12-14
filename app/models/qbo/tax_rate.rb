class Qbo::TaxRate < Qbo::Base
  def initialize(tax_id, credential = nil)
    @credential = credential
    @record = service.fetch_by_id(tax_id)
  end

  private

  def service_class
    Quickbooks::Service::TaxRate
  end
end
