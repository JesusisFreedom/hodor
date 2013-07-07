@Hodor.module "InvoiceRequest.Form.Views", (Views, App, Backbone, Marionette, $, _ ) ->

	class Views.RequestForm extends App.Views.ItemView
    template: JST["app/templates/invoice/requestForm.us"]

    events:
      'submit form': 'submitRequest'

    initialize: ->
      @errors = []
      @API_KEY_INPUT = "input[name='apiKey']"

    submitRequest: (domEvent)->
      domEvent.preventDefault()
      form = $(domEvent.currentTarget)
      credentials =
        apiKey: 	form.find(@API_KEY_INPUT).val(),
        password:	form.find("input[name='password']").val(),
        name:     form.find("input[name='togglrName']").val()
      dates = {startDate:	@getStartDate(form), endDate: @getEndDate(form)}
      hourlyRate = form.find("input[name='hourlyRate']").val()
      if ValueValidator.isPresent(credentials.apiKey)
        @getFromToggl credentials, dates, hourlyRate
      else
        console.warn " API KEY is NOT PRESENT"
        @errors.push {name: 'Please provide your API Key!'}
        errorMessages = new App.AlertMessages.Models.Messages(@errors)
        App.execute "messages:display", errorMessages

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
