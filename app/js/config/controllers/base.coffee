@Hodor.module "Controllers", (Controllers, App, Backbone, Marionette, $, _) ->

  # The Base Controller that encapsulates all common behaviour across
  # all controllers.
  class Controllers.Base extends Marionette.Controller

    constructor: (options = {}) ->
      @region = options.region or App.request "default:region"
      super options
      @_instance_id = _.uniqueId("controller")

    close: (args...) ->
      delete @region
      delete @options
      super args

    show: (view) ->
      @listenTo view, "close", @close
      @region.show view