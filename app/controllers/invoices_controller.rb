# frozen_string_literal: true
class InvoicesController < ApplicationController


  include Kaminari

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
    pageinate = invoice_service.all_debit
    @invoices = Kaminari.paginate_array(pageinate).page(params[:page]).per(10)
  end

  def invoice
    invoice_service = ::InvoiceService.new(@credential)
    pageinate = invoice_service.all_invoice
    @invoices = Kaminari.paginate_array(pageinate).page(params[:page]).per(10)
  end

  private

  def set_qbo_credential
    @credential = current_user.qbo_credentials.find(params[:company_id])
  end

  def set_invoices
    invoice_service = ::InvoiceService.new(@credential)
    @invoices = if params[:id].present?
      pageinate = invoice_service.find_by_doc_ids([params[:id]])
      Kaminari.paginate_array(pageinate).page(params[:page]).per(10)
    else
      pageinate = invoice_service.all
      Kaminari.paginate_array(pageinate).page(params[:page]).per(10)
    end
  end
end
