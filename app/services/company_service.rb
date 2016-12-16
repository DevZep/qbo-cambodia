class CompanyService < BaseService
  def find(id)
    item = service.fetch_by_id(id)
    Qbo::Company.new(item)
  end

  private

  def service_class
    Quickbooks::Service::CompanyInfo
  end
end
