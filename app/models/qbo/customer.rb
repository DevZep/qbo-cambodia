class Qbo::Customer < Qbo::Base
  def full_name
    @record.fully_qualified_name
  end

  def full_billing_address
    billing_address.present? or return

    [
      billing_address.line1,
      billing_address.city,
      [billing_address.country_sub_division_code, billing_address.postal_code].compact.join(' ')
    ].compact.join(', ')
  end

  private

  def billing_address
    @record.billing_address
  end
end
