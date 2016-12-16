class TranslationCustomersController < ApplicationController
  def create
    @translation = Translation::Customer.new(qbo_customer_id: params[:customer_id])
    @translation.assign_attributes(customer_translation_params)

    respond_to do |format|
      if @translation.save
        format.js { render inline: "window.open('#{pdf_path}', '_blank'); location.reload();", status: :ok }
      else
        format.js { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @translation = Translation::Customer.find_by!(qbo_customer_id: params[:customer_id])


  end

  private

  def customer_translation_params
    params.require(:translation_customer).permit(:name, :billing_address)
  end

  def pdf_path
    company_invoice_path(params[:company_id], params[:invoice_id], format: 'pdf')
  end
end