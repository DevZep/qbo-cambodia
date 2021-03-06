class Views.Companies.IndexView extends Views.ApplicationView
  render: ->
    _setupIntuit()

  _setupIntuit= ->
    grantUrl: 'http://www.mycompany.com/HelloWorld/RequestTokenServlet'
    datasources:
      quickbooks: true
      payments: true
    paymentOptions:
      intuitReferred: true

    $qboImg = $('#qboimg')
    $qboImg.mouseover ->
      src = $(@).data('mouseover-src')
      $(@).attr('src', src)
    $qboImg.mouseout ->
      src = $(@).data('origin-src')
      $(@).attr('src', src)