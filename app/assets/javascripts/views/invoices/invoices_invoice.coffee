class Views.Invoices.InvoiceView extends Views.ApplicationView
  render: ->
    transactionElement = $('#invoices-invoice')
    new Views.Invoices.Modal().onOpenModal(transactionElement)

  
 
