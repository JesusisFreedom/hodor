@Hodor.module "AlertMessages.Models", (Models, App, Backbone, Marionette, $, _ ) ->

  class Models.Message extends App.Entities.Model

  class Models.Messages extends Backbone.Collection
    model: Models.Message
