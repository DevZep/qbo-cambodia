class Views.Invoices.IndexView extends Views.ApplicationView
  render: ->
    _editTranslation()

  _editTranslation = ->
    $modal = $('#translation-modal')

    $('#invoices-index').on 'click', 'a.translation', ->
      $invoice = $(@).parents('tr:first')
      customerName = $invoice.data('customer-name')
      billingAddress = $invoice.data('billing-address')
      invoiceId = $invoice.data('invoice-id')

      $modal.find('form #customer-name-en:first').val(customerName)
      $modal.find('form #billing-address-en:first').val(billingAddress)
      $modal.find('form #invoice_id:first').val(invoiceId)

      submitUrl = $invoice.data('translation-url')
      $modal.find('form:first').attr('action', submitUrl)
