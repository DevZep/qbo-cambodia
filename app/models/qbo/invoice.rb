class Qbo::Invoice < Qbo::Base
  def initialize(invoice_or_invoice_doc_number, credential = nil)
    @credential = credential

    @record = if invoice_or_invoice_doc_number.is_a?(Quickbooks::Model::Invoice)
      invoice_or_invoice_doc_number
    else
      service.find_by(:doc_number, invoice_or_invoice_doc_number).entries.first
    end
  end

  def customer_name
    customer.full_name
  end

  def full_billing_address
    customer.full_billing_address
  end

  def customer_email
    customer.primary_email_address.try(:address)
  end

  def customer_tel
    customer.primary_phone.try(:free_form_number)
  end

  def created_date
    meta_data.create_time.to_date
  end

  def customer
    return @customer if @customer.present?

    @customer = Qbo::Customer.new(@record.customer_ref.value, credential)

    @customer
  end

  private

  def service_class
    Quickbooks::Service::Invoice
  end
end
