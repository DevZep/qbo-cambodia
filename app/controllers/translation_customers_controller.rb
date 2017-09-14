class TranslationCustomersController < ApplicationController
  before_action :set_qbo_credential

  def update
    @translation = Translation::Customer.find_or_initialize_by(qbo_customer_id: params[:customer_id], company_id: @qbo_credential.company_id)

    @translation.assign_attributes(customer_translation_params)

    respond_to do |format|
      if @translation.save
        format.js { render inline: "window.open('#{pdf_path}', '_blank'); location.reload();", status: :ok }
      else
        format.js { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @customer = params[:customer]
    @customer_translation = Translation::Customer.find_by(qbo_customer_id: params[:id], company_id: @customer[:company_id])
    customer_service = ::CustomerService.new(@qbo_credential)
  end

  private

  def set_qbo_credential
    @qbo_credential = QboCredential.find(params[:company_id])
  end

  def customer_translation_params
    params.require(:translation_customer).permit(:name, :billing_address)
  end

  def pdf_path
    company_invoice_path(params[:company_id], params[:invoice_id], format: 'pdf')
  end
end
