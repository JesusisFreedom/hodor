@Hodor.module "AlertMessages.Views", (Views, App, Backbone, Marionette, $, _ ) ->

  class Views.ErrorItemView extends App.Views.ItemView
    template: JST["app/templates/messages/messages.us"]

  class Views.ErrorsCollectionView extends App.Views.CollectionView
    itemView: Views.ErrorItemView
    tagName: 'li'
    className: 'alert-list'
