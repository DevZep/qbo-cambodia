class InvoiceService < BaseService

  $query_items = 'ID,Line, CustomerRef, DocNumber, CurrencyRef, TotalAmt, TxnDate, DueDate'.gsub(/'/,"") 

  def get_all_invoices
    @invoices = []
    @items = service.query("SELECT #{$query_items} FROM Invoice ORDER BY DocNumber DESC", per_page: 1000).entries
    @items.map do |item|
      invoice = Qbo::Invoice.new(item)
      invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
      invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
      @invoices << invoice
    end
    @invoices

  end

  def all
    invoices = []
    @items = @invoices
    @items.map do |item|
      if item.doc_number.start_with?('DNRTT','RTT','CIRTT')
        invoice = Qbo::Invoice.new(item)
        invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
        invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
        invoice.valid = valid_id_sequence?(@items,item.doc_number)
        invoices << invoice
      end
    end
    invoices
  end

  def need_attention
    invoices = []
    @items = @invoices
    @items.map do |item|
      if !item.doc_number.start_with?('DNRTT','RTT','CIRTT')
        invoice = Qbo::Invoice.new(item)
        invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
        invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
        invoices << invoice
      end
    end
    invoices
  end

  def find_by_doc_ids(doc_ids)
    query = "SELECT #{$query_items} FROM Invoice WHERE DocNumber Like '%#{doc_ids}' ".gsub(/"/,"").gsub('[', '').gsub(']', '')
    @items = service.query(query).entries
    @items.map do |item|
      invoice = Qbo::Invoice.new(item)
      invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
      invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
      invoice
    end
  end

  def find_show_receipt_by_doc_ids(doc_ids)
    query = "SELECT #{$query_items} FROM Invoice WHERE DocNumber = '#{doc_ids}'".gsub(/"/,"").gsub('[', '').gsub(']', '')
    
    @items = service.query(query).entries
    @items.map do |item|
      invoice = Qbo::Invoice.new(item)
      invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
      invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
      invoice
    end
  end

  def all_debit
    invoices = []
    @items = @invoices
    @items.map do |item|
      if item.doc_number.start_with?('DNRTT')
        invoice = Qbo::Invoice.new(item)
        invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
        invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
        invoice.valid = valid_id_sequence?(@items,item.doc_number)
        invoices << invoice
      end
    end
    invoices

  end

  def all_invoice
    invoices = []
    @items = @invoices
    @items.map do |item|
      if item.doc_number.start_with?('RTT')
        invoice = Qbo::Invoice.new(item)
        invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
        invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
        invoice.valid = valid_id_sequence?(@items,item.doc_number)
        invoices << invoice
      end
    end
    invoices
  end

  def all_commercial
    invoices = []
    @items = @invoices
    @items.map do |item|
      if item.doc_number.start_with?('CIRTT')
        invoice = Qbo::Invoice.new(item)
        invoice.customer = customers.find { |customer| customer.id == invoice.customer_id }
        invoice.customer_translation = customer_translations.find { |ct| ct.qbo_customer_id == invoice.customer_id.to_i }
        invoice.valid = valid_id_sequence?(@items,item.doc_number)
        invoices << invoice
      end
    end
    invoices
  end

  private

  def valid_id_sequence?(all_items, doc_id)
    array = []
    valid_nums = []
    number = doc_id.split("-")[1]

    all_invoices = invoices_by_type(all_items, doc_id)

    all_invoices.reverse.pluck('doc_number').map { |item| array << item.split('-')[1].to_i }

    array.each_with_index do |item,index|
      valid_nums << array[index]
      break if index != array.size && array[index]+1 != array[index+1]
    end

    if number.length == 9
      fix_num = number.to_i
      if valid_nums.include?(fix_num)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def invoices_by_type(all_items, doc_id)
    prefix = doc_id.split('-')[0]
    invoices = all_items.group_by {|invoice| invoice.doc_number.split("-")[0]}
    invoices[prefix]
  end

  def customers
    return @customers if @customers.present?

    customer_service = CustomerService.new(qbo_credential)
    @customers = customer_service.find_by_ids(customer_ids)
  end

  def customer_translations
    @customer_translations ||= Translation::Customer.where(company_id: qbo_credential.company_id, qbo_customer_id: customer_ids, language_code: 'km')
  end

  def customer_ids
    return [] if @items.blank?
    @items.map { |invoice| invoice.customer_ref.value }
  end

  def service_class
    Quickbooks::Service::Invoice
  end
end
