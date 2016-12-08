# frozen_string_literal: true
class InvoicesController < ApplicationController
  before_action :set_company
  before_action :set_invoices, except: :show

  def index

  end

  def show;end

  private

  def set_company
    @company = current_user.companies.find(params[:id])
  end

  def set_invoices
    auth = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, @company.access_token, @company.access_secret)
    service  = Quickbooks::Service::Invoice.new(access_token: auth, realm_id: @company.company_id)

    response = if params[:invoice_id].present?
      service.query("SELECT * FROM Invoice WHERE Id = '#{params[:invoice_id]}' ORDERBY MetaData.CreateTime DESC")
    else
      service.query('SELECT * FROM Invoice ORDERBY MetaData.CreateTime DESC')
    end

    @invoices = response.entries
  end
end
