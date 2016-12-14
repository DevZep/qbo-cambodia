# frozen_string_literal: true
class InvoicesController < ApplicationController
  layout false, only: :show

  before_action :set_qbo_credential
  before_action :set_company
  before_action :set_invoices
  # before_action :set_qbo_company, only: :show

  def index

  end

  def show
    @invoice = @invoices.first

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@company.name.parameterize}_invoice_#{@invoice.doc_number}",
          template: 'invoices/show.html.haml',
          margin:  {
            left: 0,
            right: 0
          }
        )
      end
    end
  end

  private

  def set_qbo_credential
    @credential = current_user.qbo_credentials.find(params[:company_id])
  end

  def set_company
    @company = Qbo::Company.new(@credential)
  end

  def set_invoices
    auth     = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, @credential.access_token, @credential.access_secret)
    service  = Quickbooks::Service::Invoice.new(access_token: auth, realm_id: @credential.company_id)

    if params[:id].present?
      @invoices = [Qbo::Invoice.new(params[:id], @credential)]
    else
      @invoices = service.query('SELECT * FROM Invoice ORDERBY MetaData.CreateTime DESC').entries.map do |raw_invoice|
        Qbo::Invoice.new(raw_invoice)
      end
    end
  end
end
