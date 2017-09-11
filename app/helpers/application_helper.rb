# frozen_string_literal: true
module ApplicationHelper

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def invoice_link(invoice, credential)
    if invoice.translated? || prefix_DNRTT?(invoice) || prefix_CIRTT?(invoice)
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
    if prefix_DNRTT?(invoice) || prefix_CIRTT?(invoice)
      content_tag :div do
        english_name(invoice,credential)
      end
    elsif invoice.translated?
      content_tag :div do
        english_name(invoice,credential) + khmer_name(invoice)
      end
    else
      content_tag :div do
        english_name(invoice,credential) + require_translation
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

  def english_name(invoice,credential)
    name = invoice.customer_name
    address = invoice.full_billing_address
    phone = invoice.customer_tel
    email = invoice.customer_email

    customer = { 'name': name, 'address': address, 'phone': phone, 'email': email }
    content_tag :p do
      link_to invoice.customer_name, customer_translation_path(credential, invoice.customer.id, customer: customer)
    end
  end

  def khmer_name(invoice)
    content_tag :span, "#{invoice.customer_translation.name} " 
  end

  def edit_name(invoice, credential)
    content_tag :a, "Translate" , href: '!#', class: 'translation edit btn btn-info',
      data: {
        toggle: 'modal',
        next: company_invoice_path(credential, invoice.doc_number),
        target: '#translation-modal'
      }
  end

  def require_translation
    content_tag :span, 'Requires Translating ', class: 'text-danger'
  end

  def nextid(doc_id,prefix)
    num = get_number(doc_id).to_i
    num += 1
    "#{prefix}-#{rjust(num)}"
  end

  def rjust(doc_id)
    doc_id.to_s.rjust(9,'0')
  end

  def prefix_RTT?(doc_id)
    if doc_id.instance_of?(String)
      doc_id.start_with?('RTT')
    else
      doc_id.doc_number.start_with?('RTT')
    end
  end

  def prefix_CIRTT?(doc_id)
    if doc_id.instance_of?(String)
      doc_id.start_with?('CIRTT')
    else
      doc_id.doc_number.start_with?('CIRTT')
    end
  end

  def prefix_DNRTT?(doc_id)
    if doc_id.instance_of?(String)
      doc_id.start_with?('DNRTT')
    else
      doc_id.doc_number.start_with?('DNRTT')
    end
  end

  def get_number(doc_id)
    if doc_id.instance_of?(String)
      doc_id.gsub(/[^\d]/, '')
    else
      doc_id.doc_number.gsub(/[^\d]/, '')
    end
  end

  def get_string(doc_id)
    if doc_id.instance_of?(String)
      doc_id.split('-')[0]
    else
      doc_id.doc_number.split('-')[0]
    end
  end

end
