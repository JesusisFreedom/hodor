@Hodor.module "InvoiceRequest.Form", (Form, App, Backbone, Marionette, $, _ ) ->

	class Form.Controller extends App.Controllers.Base
		initialize: ->
      @listenForDataRequest()
      @show @createFormView()

		createFormView: ->
      new App.InvoiceRequest.Form.Views.RequestForm

    listenForDataRequest: ->
      App.commands.setHandler 'timeEntries:requestData', @fetchTimeEntries

    fetchTimeEntries: (options) =>
      @timeEntries = App.request 'timeEntries:fetch', options.credentials.apiKey, options.dates['startDate'], options.dates['endDate']
      App.commands.execute "when:fetched", @timeEntries, =>
        summaryOptions =
          name: options.credentials.name
          dates: options.dates
          hourlyRate: options.hourlyRate
          totalTime: @timeEntries.sumOfBillableTime()
        timeEntriesSummary = App.request "timeEntries:getSummary", summaryOptions
        summaryView = new App.InvoiceRequest.Form.Views.Summary(model: timeEntriesSummary)
        App.mainRegion.show summaryView
