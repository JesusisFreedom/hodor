@Hodor.module 'Router', (Router, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	class Router.AppRouter extends Marionette.AppRouter
    appRoutes:
      '': 'index'
      'index': 'index'
      '*path': 'index'

	API =
		index: ->
      new App.InvoiceRequest.Form.Controller()
      new App.AlertMessages.Controller
        region: App.messagesRegion

	Router.on 'start', ->
		new Router.AppRouter
			controller: API
