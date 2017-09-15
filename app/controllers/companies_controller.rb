class CompaniesController < ApplicationController
  before_action :set_qbo_credential, only: :show
  # before_action :companies
  before_action :show_next_id, only: :show

  
  def index
    if current_user.last_login_company.present? && params[:error] != 'true'
      redirect_to company_path(current_user.last_login_company)
    end
  end

  def show
    @company = current_user.qbo_credentials.find_by(company_id: params[:id])
  end

  private
  # def companies
  #   @companies = current_user.qbo_credentials
  #   @debits = []
  #   @invoices = []
  #   @commercial = []
  #   @companies.each do |item|

  #     invoice_service = ::InvoiceService.new(item)
  #     begin
  #       invoice_service.get_all_invoices
  #     rescue Quickbooks::AuthorizationFailure => e
  #       if e == Quickbooks::AuthorizationFailure
  #         redirect_to root_path
  #       end
  #     end
  #     #show next available id
  #     @debits << doc_number_present(invoice_service.all_debit,"DNRTT-")
  #     @invoices << doc_number_present(invoice_service.all_invoice,"RTT-")
  #     @commercial << doc_number_present(invoice_service.all_commercial,"CIRTT-")
  #   end
  # end

  def set_qbo_credential
    @credential = current_user.qbo_credentials.find_by(company_id: params[:id])
  end

  def show_next_id
    begin
      invoice_service = ::InvoiceService.new(@credential)
      invoice_service.get_all_invoices

      @invoice = doc_number_present(invoice_service.all_invoice,"RTT-")
      @debit = doc_number_present(invoice_service.all_debit,"DNRTT-")
      @commercial = doc_number_present(invoice_service.all_commercial,"CIRTT-")
    rescue Exception => e
      redirect_to action: 'index', error: true
    end
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