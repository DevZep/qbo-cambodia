# frozen_string_literal: true
class InvoicesController < ApplicationController
  layout false, only: :show

  before_action :set_qbo_credential
  before_action :set_invoices

  def index

  end

  def show
    @invoice = @invoices.first

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@credential.company_name.parameterize}_invoice_#{@invoice.doc_number}",
          template: 'invoices/show.html.haml',
          margin:  {
            left: 0,
            right: 0
          }
        )
      end
    end
  end

  def debit
    invoice_service = ::InvoiceService.new(@credential)
    @invoices = invoice_service.all_debit
  end

  def invoice
    invoice_service = ::InvoiceService.new(@credential)
    @invoices = invoice_service.all_invoice
    
  end

  private

  def set_qbo_credential
    @credential = current_user.qbo_credentials.find(params[:company_id])
  end

  def set_invoices
    invoice_service = ::InvoiceService.new(@credential)
    @invoices = if params[:id].present?
      invoice_service.find_by_doc_ids([params[:id]])
    else
      invoice_service.all
    end
  end
end
