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
    meta_data.create_time.to_date.strftime('%d-%b-%Y')
  end

  def created_date_km
    date = meta_data.create_time.to_date

    day_km = date.day.to_s.split('').map { |num| NUMBER_EN_KM[num] }.join('')
    month_km = MONTH_EN_KM[date.month.to_s]
    year_km = date.year.to_s.split('').map { |num| NUMBER_EN_KM[num] }.join('')

    [day_km, month_km, year_km].join('-')
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
