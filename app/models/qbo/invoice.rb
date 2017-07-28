# frozen_string_literal: true
module Qbo
  class Invoice < Qbo::Base
    attr_accessor :customer, :customer_translation, :valid

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

    def discount_percent
      percent = line_items.last.discount_line_detail.discount_percent
      percent.present? ? "(#{percent.to_i} %)" : ""
    end

    def discount_amount
      line_items.last.amount
    end

    # def customer
    #   @customer
    # end

    # def valid
    #   @valid
    # end

    # def customer_translation
    #   @customer_translation
    # end

    def translated?
      customer_translation.present?
    end

    def title
      if debit_note?
        'DEBIT NOTE'
      elsif invoice_note?
        'TAX INVOICE'
      else
        'COMMERICAL INVOICE'
      end
    end

    def title_kh
      if debit_note?
        'ការទូទាត់សងវិញ'
      elsif invoice_note?
        'វិក្ក័យបត្រអាករ'
      else
        'វិក្ក័យបត្រធម្មតា'
      end
    end

    def debit_note?
      doc_number.present? && doc_number.start_with?('DNRTT')
    end

    def invoice_note?
      doc_number.present? && doc_number.start_with?('RTT')
    end

    def commercial_note?
      doc_number.present? && doc_number.start_with?('CIRTT')
    end
  end
end
