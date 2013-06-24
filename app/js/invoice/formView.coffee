@Hodor.module "InvoiceRequest.Form.Views", (Views, App, Backbone, Marionette, $, _ ) ->

	class Views.RequestForm extends App.Views.ItemView
    template: JST["app/templates/invoice/requestForm.us"]

    events:
      'submit form': 'submitRequest'

    initialize: ->
      console.log "initializing request form"

    submitRequest: (domEvent)->
      domEvent.preventDefault()
      form = $(domEvent.currentTarget)
      credentials =
        apiKey: 	form.find("input[name='apiKey']").val(),
        password:	form.find("input[name='password']").val(),
        name:     form.find("input[name='togglrName']").val()
      dates = {startDate:	@getStartDate(form), endDate: @getEndDate(form)}
      hourlyRate = form.find("input[name='hourlyRate']").val()
      @getFromToggl credentials, dates, hourlyRate

    getStartDate: (form) ->
      form.find("input[name='startDate']").val()

    getEndDate: (form) ->
      form.find("input[name='endDate']").val()

    getFromToggl: (credentials, dates, hourlyRate) ->
      options =
        credentials: credentials
        dates: {startDate: moment(dates.startDate, 'DD-MM-YYYY'), endDate: moment(dates.endDate, 'DD-MM-YYYY')}
        hourlyRate: hourlyRate
      App.execute "timeEntries:requestData", options
