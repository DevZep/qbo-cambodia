class Views.Invoices.IndexView extends Views.ApplicationView
  render: ->
    _editTranslation()
    _newTranslation()
    _onOpenModal()

  _onOpenModal= ->
    $modal = $('#translation-modal')

    $('#invoices-index').on 'click', 'a.translation', ->
      $invoice = $(@).parents('tr:first')

      # Customer info: En
      customerName = $invoice.data('customer-name')
      billingAddress = $invoice.data('billing-address')
      invoiceId = $invoice.data('invoice-id')

      $modal.find('form #customer-name-en:first').val(customerName)
      $modal.find('form #billing-address-en:first').val(billingAddress)
      $modal.find('form #invoice_id:first').val(invoiceId)

      # Customer info: Km
      customerNameKm = $invoice.data('translation-name')
      billingAddressKm = $invoice.data('translation-billing-address')
      $modal.find('form #translation_customer_name:first').val(customerNameKm)
      $modal.find('form #translation_customer_billing_address:first').val(billingAddressKm)

      # From action
      submitUrl = $invoice.data('translation-url')
      $modal.find('form:first').attr('action', submitUrl)

  _newTranslation = ->
    $modal = $('#translation-modal')

    $('#invoices-index').on 'click', 'a.translation.new', ->
      $modal.find('form .btn-success:first').text('Translate and View Invoice')
      $modal.find('form:first').attr('method', 'POST')

  _editTranslation = ->
    $modal = $('#translation-modal')

    $('#invoices-index').on 'click', 'a.translation.edit', ->
      $modal.find('form .btn-success:first').text('Save and View Invoice')
      $modal.find('form:first').attr('method', 'PUT')
