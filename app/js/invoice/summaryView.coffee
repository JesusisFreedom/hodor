@Hodor.module "InvoiceRequest.Form.Views", (Views, App, Backbone, Marionette, $, _ ) ->

  class Views.Summary extends App.Views.ItemView
    template: JST["app/templates/invoice/invoice.us"]

