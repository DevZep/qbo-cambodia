class CompaniesController < ApplicationController
  before_action :set_qbo_credential, only: :show
  before_action :debit, only: :show
  before_action :invoice, only: :show

  def index
    @companies = current_user.qbo_credentials
  end

  def show
    @company = current_user.qbo_credentials.find(params[:id])
  end

  private
    def set_qbo_credential
      @credential = current_user.qbo_credentials.find(params[:id])
    end

    def debit
      invoice_service = ::InvoiceService.new(@credential)
      get_all_invoice = invoice_service.get_all_invoices

      @debit = invoice_service.all_debit
    end

    def invoice
      invoice_service = ::InvoiceService.new(@credential)
      get_all_invoice = invoice_service.get_all_invoices
      
      @invoice = invoice_service.all_invoice
    end
end