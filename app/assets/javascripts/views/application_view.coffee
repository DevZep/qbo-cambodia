class Views.ApplicationView
  render: ->
    _autoCloseAlert()
  cleanup: ->


  _autoCloseAlert= ->
    $('.alert').fadeTo(3000, 500).slideUp 500, ->
      $('.alert').slideUp 500
