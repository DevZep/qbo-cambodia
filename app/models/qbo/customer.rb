class Qbo::Customer < Qbo::Base
  def full_name
    @record.fully_qualified_name
  end

  def full_billing_address
    billing_address.present? or return

    [
      billing_address.line1,
      billing_address.line2,
      billing_address.line3,
      billing_address.line4,
      billing_address.line5,
      billing_address.city,
      [billing_address.country_sub_division_code, billing_address.postal_code].compact.join(' '),
      billing_address.country    
    ].compact.join(', ')
  end

  private

  def billing_address
    @record.billing_address
  end
end
