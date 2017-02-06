class CompaniesController < ApplicationController
  before_action :set_qbo_credential, only: :show
  before_action :companies
  before_action :show_next_id, only: :show

  
  def index
    
  end

  def show
    @company = current_user.qbo_credentials.find(params[:id])
  end

  private
    def companies
      @companies = current_user.qbo_credentials
      @debits = []
      @invoices = []
      @commercial = []
      @companies.each do |item|

        invoice_service = InvoiceService.new(item)
        begin
          get_all_invoice = invoice_service.get_all_invoices
        rescue Quickbooks::AuthorizationFailure => e
          if e == Quickbooks::AuthorizationFailure
            redirect_to root_path, notice: "Fail"
          end
        end
        #show both next available id
        @debits << doc_number_present(invoice_service.all_debit,"DNRTT-")
        @invoices << doc_number_present(invoice_service.all_invoice,"RTT-")
        @commercial << doc_number_present(invoice_service.all_commercial,"CIRTT-")
      end
    end

    def set_qbo_credential
      @credential = current_user.qbo_credentials.find(params[:id])
    end

    def show_next_id
      invoice_service = ::InvoiceService.new(@credential)
      get_all_invoice = invoice_service.get_all_invoices

      #show both next available id
      @invoice = doc_number_present(invoice_service.all_invoice,"RTT-")
      @debit = doc_number_present(invoice_service.all_debit,"DNRTT-")
      @commercial = doc_number_present(invoice_service.all_commercial,"CIRTT-")
    end

    def doc_number_present(values,prefix)
      if values.present?
        value = ''
        array = []
        values.pluck('doc_number').map { |item| array << item.gsub(prefix,'').to_i }

        array.each do |item|
          if array.include?(array.max-1)
            value = "prefix-#{array.max.to_s.rjust(9,'0')}"
          else
            next_num = item + 1
            previous_num = item - 1
            next if array.include?(next_num)
            value = "prefix-#{item.to_s.rjust(9,'0')}"
          end
        end
        value
      else
        value = "0".rjust(9,'0')
      end
    end
end