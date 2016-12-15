pageLoad = ->
  className = $('body').attr('data-js-class')
  window.applicationView = try
    eval("new #{className}()")
  catch error
    new Views.ApplicationView()
  window.applicationView.render()

  window.appLoad = try
    eval('new Views.ApplicationView')
  window.appLoad.render()


$(document).on "ready", pageLoad
$(document).on 'page:load', pageLoad
$(document).on 'page:before-change', ->
  window.applicationView.cleanup()
  true
$(document).on 'page:restore', ->
  window.applicationView.cleanup()
  pageLoad()
  true
