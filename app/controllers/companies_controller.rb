class CompaniesController < ApplicationController
  before_action :set_qbo_credential, only: :show
  before_action :companies
  before_action :debit, only: :show
  before_action :invoice, only: :show
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
      @companies.each do |item|

        invoice_service = InvoiceService.new(item)
        get_all_invoice = invoice_service.get_all_invoices
        #show both next available id
        @debits << doc_number_present(invoice_service.all_debit)
        @invoices << doc_number_present(invoice_service.all_invoice)
      end
    end

    def set_qbo_credential
      @credential = current_user.qbo_credentials.find(params[:id])
    end

    def debit
      invoice_service = ::InvoiceService.new(@credential)
      get_all_invoice = invoice_service.get_all_invoices

      #show both next available id
      @invoice = doc_number_present(invoice_service.all_invoice)
      @debit = doc_number_present(invoice_service.all_debit)
    end

    def invoice
      invoice_service = ::InvoiceService.new(@credential)
      get_all_invoice = invoice_service.get_all_invoices

      #show both next available id
      @debit = doc_number_present(invoice_service.all_debit)
      @invoice = doc_number_present(invoice_service.all_invoice)
    end

    def doc_number_present(values)
      values.present? ? values.last.doc_number : '0'.rjust(9,'0')
    end
end