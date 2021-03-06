class Views.ApplicationView
  render: ->
    _autoCloseAlert()
    _active()
  cleanup: ->


  _autoCloseAlert= ->
    $('.alert').fadeTo(3000, 500).slideUp 500, ->
      $('.alert').slideUp 500

  _active= ->
    body = $('body').attr('id')
    if body == 'invoices-invoice'
      $('#invoice').addClass('alert-info')
    else if body == 'invoices-debit'
      $('#debit').addClass('alert-info')
    else if body == 'invoices-index'
      $('#all').addClass('alert-info')
    else if body == 'invoices-need_attention'
      $('#need_attention').addClass('alert-info')
    else if body == 'invoices-commercial'
      $('#commercial').addClass('alert-info')