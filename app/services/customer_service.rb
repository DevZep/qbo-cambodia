class CustomerService < BaseService

  def find_by_ids(ids)
    query = "SELECT * FROM Customer WHERE ID IN (#{ids})".gsub(/"/,"'").gsub('[', '').gsub(']', '')
    @items = service.query(query).entries
    @items.map do |customer|
      Qbo::Customer.new(customer)
    end
  end

  def find_by_id(id)
    query = "SELECT * FROM Customer WHERE ID = '#{id}'".gsub(/"/,"'").gsub('[', '').gsub(']', '')
    @items = service.query(query).entries.first
    Qbo::Customer.new(@items)
  end

  private

  def service_class
    Quickbooks::Service::Customer
  end
end
