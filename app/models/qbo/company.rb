class Qbo::Company < Qbo::Base
  def name
    @record.company_name
  end

  def vattin

  end

  def email
    @record.email.address
  end

  def tel
    @record.primary_phone.free_form_number
  end

  def full_address
    [
      address.line1,
      address.city,
      address.country
    ].compact.join(', ')
  end

  private

  def address
    @record.company_address
  end
end
