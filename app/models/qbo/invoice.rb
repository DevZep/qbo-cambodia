class Qbo::Invoice < Qbo::Base
  attr_writer :customer, :customer_translation

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

  def txn_date_formated
    txn_date.strftime('%d-%b-%Y')
  end

  def txn_date_formated_km
    date = txn_date

    day_km = date.day.to_s.split('').map { |num| NUMBER_EN_KM[num] }.join('')
    month_km = MONTH_EN_KM[date.month.to_s]
    year_km = date.year.to_s.split('').map { |num| NUMBER_EN_KM[num] }.join('')

    [day_km, month_km, year_km].join('-')
  end

  def currency
    @currency ||= ::ISO4217::Currency.from_code(currency_ref.value)
  end

  def sub_total
    @sub_total ||= line_items.find(&:sub_total_item?)
  end

  def customer_id
    customer_ref.value
  end

  def customer
    # return @customer if @customer.present?
    #
    # customer_service = CustomerService.new(qbo_credential)
    # customer_service.find_by_ids(customer_ids)
    #
    # @customer = Qbo::Customer.new(customer_ref.value, credential)

    @customer
  end

  def customer_translation
    @customer_translation
    # @customer_translation ||= Translation::Customer.find_by(qbo_customer_id: customer_ref.value)
  end

  def translated?
    customer_translation.present?
  end

  def title
    debit_note? ? 'DEBIT NOTE' : 'TAX INVOICE'
  end

  def title_kh
    debit_note? ? '': 'វិក្ក័យបត្រអាករ'
  end

  def debit_note?
    private_note.present? && private_note.include?('debit_note')
  end

end
