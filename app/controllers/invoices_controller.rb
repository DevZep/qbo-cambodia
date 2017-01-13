# frozen_string_literal: true
class InvoicesController < ApplicationController

  include Kaminari

  layout false, only: :show

  before_action :set_qbo_credential
  before_action :set_invoices

  def index

  end

  def show
    @invoice = @all.first

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@invoice.doc_number}-#{@credential.company_name.parameterize}-rotati-ltd",
          template: 'invoices/show.html.haml',
          margin:  {
            left: 0,
            right: 0
          }
        )
      end
    end
  end

  def receipt
    @invoice = @all.first
    
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@invoice.doc_number}-#{@credential.company_name.parameterize}-rotati-ltd",
          template: 'invoices/_receipt.haml',
          margin:  {
            left: 0,
            right: 0
          }
        )
      end
    end
  end

  def need_attention
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    paginate = invoice_service.need_attention
    @need_attentions = Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    #show both next available ID
    @invoice_no = doc_number_present(invoice_service.all_invoice())
    @debit_no = doc_number_present(invoice_service.all_debit())

  end

  def debit
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    paginate = invoice_service.all_debit
    @debits = Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    #show both next available ID
    @invoice_no = doc_number_present(invoice_service.all_invoice())
    @debit_no = doc_number_present(invoice_service.all_debit())
    
  end

  def invoice
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    paginate = invoice_service.all_invoice
    @invoices = Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    #show both next available ID
    @invoice_no = doc_number_present(invoice_service.all_invoice())
    @debit_no = doc_number_present(invoice_service.all_debit())
  end

  private

  def set_qbo_credential
    @credential = current_user.qbo_credentials.find(params[:company_id])
  end

  def set_invoices
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    @all = if params[:id].present?
      paginate = invoice_service.find_by_doc_ids([params[:id]])
      Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    else
      paginate = invoice_service.all
      Kaminari.paginate_array(paginate).page(params[:page]).per(10)
    end

    #show both next available ID
    @invoice_no = doc_number_present(invoice_service.all_invoice())
    @debit_no = doc_number_present(invoice_service.all_debit())
  end

  def doc_number_present(values)
    values.present? ? values.last.doc_number : "0".rjust(9,'0')
  end
end
