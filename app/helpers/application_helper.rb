# frozen_string_literal: true
module ApplicationHelper

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def invoice_link(invoice, credential)
    if invoice.translated?
      link_to invoice.doc_number, company_invoice_path(invoice.credential, invoice.doc_number, format: :pdf), target: '_blank'
    else
      link_to(
        invoice.doc_number, '!#',
        class: 'translation',
        data: {
          toggle: 'modal',
          next: company_invoice_path(credential, invoice.doc_number),
          target: '#translation-modal'
        }
      )
    end
  end
end
