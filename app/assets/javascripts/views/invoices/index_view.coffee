class Views.Invoices.IndexView extends Views.ApplicationView
  render: ->
    transactionElement = $('#invoices-index')
    new Views.Invoices.Modal().onOpenModal(transactionElement)

  
 
