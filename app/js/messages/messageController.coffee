@Hodor.module "AlertMessages", (AlertMessages, App, Backbone, Marionette, $, _ ) ->

  class AlertMessages.Controller extends App.Controllers.Base
    initialize: (options) ->
      @region = options.region
      @listenForMessages()
      @show @createMessagesView(null)
      @_messagesView.$el.hide()

    listenForMessages: ->
      App.commands.setHandler "messages:display", (messageCollection) =>
        @_messagesView.$el.show()
        @getMessagesView(messageCollection).render()

    getMessagesView: (messagesCollection) ->
      @_messagesView.collection = messagesCollection
      @_messagesView

    createMessagesView: (messagesCollection) ->
      @_messagesView = new AlertMessages.Views.ErrorsCollectionView
        collection: messagesCollection
      @_messagesView