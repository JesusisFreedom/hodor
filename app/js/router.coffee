@Hodor.module 'Router', (Router, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	class Router.AppRouter extends Marionette.AppRouter
    appRoutes:
      '': 'index'
      'index': 'index'
      '*path': 'index'

	API =
		index: ->
			console.log "in index.."
			new App.InvoiceRequest.Form.Controller

	Router.on 'start', ->
  	console.log "starting router.."
		new Router.AppRouter
			controller: API
