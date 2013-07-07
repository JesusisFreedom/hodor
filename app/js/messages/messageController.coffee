@Hodor.module "AlertMessages", (AlertMessages, App, Backbone, Marionette, $, _ ) ->

  class AlertMessages.Controller extends App.Controllers.Base
    initialize: (options) ->
      @listenForMessages()

    listenForMessages: ->
      App.commands.setHandler "messages:display", (messageCollection) =>
        @show @getMessagesView(messageCollection)

    getMessagesView: (messagesCollection) ->
      new AlertMessages.Views.ErrorsCollectionView
        collection: messagesCollection