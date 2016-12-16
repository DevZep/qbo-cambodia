class CustomerService < BaseService

  def find_by_ids(ids)
    query = "SELECT * FROM Customer WHERE ID IN (#{ids})".gsub(/"/,"'").gsub('[', '').gsub(']', '')
    @items = service.query(query).entries
    @items.map do |customer|
      Qbo::Customer.new(customer)
    end
  end

  private

  def service_class
    Quickbooks::Service::Customer
  end
end
