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
            redirect_to root_path, alert: "Please Re-Authenticate"
          end
        end
        #show both next available id
        @debits << doc_number_present(invoice_service.all_debit)
        @invoices << doc_number_present(invoice_service.all_invoice)
        @commercial << doc_number_present(invoice_service.all_commercial)
      end
    end

    def set_qbo_credential
      @credential = current_user.qbo_credentials.find(params[:id])
    end

    def show_next_id
      invoice_service = ::InvoiceService.new(@credential)
      get_all_invoice = invoice_service.get_all_invoices

      #show both next available id
      @invoice = doc_number_present(invoice_service.all_invoice)
      @debit = doc_number_present(invoice_service.all_debit)
      @commercial = doc_number_present(invoice_service.all_commercial)
    end

    def doc_number_present(values)

      if values.present?
        value = ''
        (0...values.length).to_a.reverse.each do |index|
          if index > 0 
            current_doc = values[index].doc_number.split("-")[1].to_i
            next_doc    = values[index-1].doc_number.split("-")[1].to_i
            unless current_doc + 1 == next_doc
              return value = values[index].doc_number
            end
          else 
            value = values[index].doc_number
          end
        end
        value
      else 
        value = "0".rjust(9,'0')
      end
    end
end