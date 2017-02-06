# frozen_string_literal: true
class InvoicesController < ApplicationController
  include Kaminari

  layout false, only: :show

  before_action :set_qbo_credential
  before_action :set_invoices

  def index

  end

  def show
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices
    @invoice = invoice_service.find_show_receipt_by_doc_ids(params[:id]).first

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@invoice.doc_number}-#{@credential.company_name.parameterize}-rotati-ltd",
          margin:  {
            right: 0,
            left: 0,
            top: 5
          },
          template: 'invoices/show.html.haml',
          layout: 'pdf',
          header: {
            html: { 
              template: 'invoices/_pdf_header.haml',
            } 
            },
          footer: {
            html: { 
              template: 'invoices/_pdf_footer.haml',
            }
          }
        )
      end
    end
  end

  def receipt
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    @invoice = invoice_service.find_show_receipt_by_doc_ids(params[:id]).first

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

    show_nextid(invoice_service)
  end

  def debit
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    paginate = invoice_service.all_debit
    @debits = Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    show_nextid(invoice_service)
  end

  def invoice
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    paginate = invoice_service.all_invoice
    @invoices = Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    show_nextid(invoice_service)
  end

  def commercial 
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    paginate = invoice_service.all_commercial
    @commercials = Kaminari.paginate_array(paginate).page(params[:page]).per(10)

    show_nextid(invoice_service)
  end

  private

  def set_qbo_credential
    @credential = current_user.qbo_credentials.find(params[:company_id])
  end

  def show_nextid(service)
    @invoice_no = doc_number_present(service.all_invoice(),"RTT-")
    @debit_no = doc_number_present(service.all_debit(),"DNRTT-")
    @commercial_no = doc_number_present(service.all_commercial(),"CIRTT-")
  end

  def set_invoices
    invoice_service = ::InvoiceService.new(@credential)
    get_all_invoices = invoice_service.get_all_invoices

    @all_invoice = if params[:id].present?
      paginate = invoice_service.find_by_doc_ids([params[:id]])
      Kaminari.paginate_array(paginate).page(params[:page]).per(10)
    else
      paginate = invoice_service.all
      Kaminari.paginate_array(paginate).page(params[:page]).per(10)
    end
    @all = @all_invoice.group_by {|invoice| invoice.doc_number.split("-")[0]}
    show_nextid(invoice_service)
  end

  def doc_number_present(values,prefix)
    if values.present?
      value = ''
      array = []
      values.pluck('doc_number').map { |item| array << item.gsub(prefix,'').to_i }

      array.each do |item|
        next_num = item + 1
        previous_num = item - 1
        next if array.include?(next_num)
        value = "prefix-#{item.to_s.rjust(9,'0')}"
      end
      value
    else
      value = "0".rjust(9,'0')
    end
  end
end
