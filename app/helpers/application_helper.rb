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
      link_to invoice.doc_number, company_invoice_path(credential, invoice.doc_number, format: :pdf), target: '_blank'
    else
      link_to(
        invoice.doc_number, '!#',
        class: 'translation new',
        data: {
          toggle: 'modal',
          next: company_invoice_path(credential, invoice.doc_number),
          target: '#translation-modal'
        }
      )
    end
  end

  def edit_translation(invoice, credential)
    if invoice.translated?
      content_tag :div do
        english_name(invoice) + khmer_name(invoice) + edit_name(invoice, credential)
      end
    else
      content_tag :div do
        english_name(invoice) + require_translation + edit_name(invoice, credential)
      end
    end.html_safe
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when 'success'
        'alert-success'
      when 'error'
        'alert-danger'
      when 'alert'
        'alert-danger'
      when 'notice'
        'alert-info'
      else
        flash_type.to_s
    end
  end

  def toggle_class(condition, class_name)
    class_name if condition
  end

  private

  def english_name(invoice)
    content_tag :p, invoice.customer_name
  end

  def khmer_name(invoice)
    content_tag :span, "#{invoice.customer_translation.name} " 
  end

  def edit_name(invoice, credential)
    content_tag :a, href: '!#', class: 'translation edit',
      data: {
        toggle: 'modal',
        next: company_invoice_path(credential, invoice.doc_number),
        target: '#translation-modal'
      } do
      content_tag :span, '', class: 'glyphicon glyphicon-edit',  aria: { hidden: true }
    end
  end

  def require_translation
    content_tag :span, 'Requires Translating ', class: 'text-danger'
  end
end
