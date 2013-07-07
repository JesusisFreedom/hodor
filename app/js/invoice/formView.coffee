@Hodor.module "InvoiceRequest.Form.Views", (Views, App, Backbone, Marionette, $, _ ) ->

	class Views.RequestForm extends App.Views.ItemView
    template: JST["app/templates/invoice/requestForm.us"]

    events:
      'submit form': 'submitRequest'

    initialize: ->
      @errors = []
      @API_KEY_INPUT = "input[name='apiKey']"
      @PASSWORD_INPUT = "input[name='password']"
      @NAME_INPUT = "input[name='togglrName']"
      @HOURLY_RATE_INPUT = "input[name='hourlyRate']"
      @START_DATE_INPUT = "input[name='startDate']"
      @END_DATE_INPUT = "input[name='endDate']"
      @API_KEY_ERROR_MESSAGE = 'Please provide your API Key!'
      @NAME_ERROR_MESSAGE = 'Please provide a name!'

    submitRequest: (domEvent)->
      domEvent.preventDefault()
      form = $(domEvent.currentTarget)
      credentials = @_getCredentials(form)
      dates = @_getDates(form)
      hourlyRate = form.find(@HOURLY_RATE_INPUT).val()
      @validateForm credentials
      if _.isEmpty(@errors)
        @getFromToggl credentials, dates, hourlyRate
      else
        errorMessages = new App.AlertMessages.Models.Messages(@errors)
        App.execute "messages:display", errorMessages

    _getCredentials: (form) ->
      credentials =
        apiKey: 	form.find(@API_KEY_INPUT).val(),
        password:	form.find(@PASSWORD_INPUT).val(),
        name:     form.find(@NAME_INPUT).val()
      credentials

    _getDates: (form) ->
      {startDate:	@getStartDate(form), endDate: @getEndDate(form)}

    getStartDate: (form) ->
      form.find(@START_DATE_INPUT).val()

    getEndDate: (form) ->
      form.find(@END_DATE_INPUT).val()

    getFromToggl: (credentials, dates, hourlyRate) ->
      options =
        credentials: credentials
        dates: {startDate: moment(dates.startDate, 'DD-MM-YYYY'), endDate: moment(dates.endDate, 'DD-MM-YYYY')}
        hourlyRate: hourlyRate
      App.execute "timeEntries:requestData", options

    validateForm: (credentials) ->
      @errors = []
      @validateApiKey credentials.apiKey
      @validateName credentials.name

    validateName: (name) ->
      if !ValueValidator.isPresent(name)
        console.warn "Name is not present!"
        @errors.push {name: @NAME_ERROR_MESSAGE}

    validateApiKey: (apiKey)->
      @errors = []
      if !ValueValidator.isPresent(apiKey)
        console.warn "API Key is not present!"
        @errors.push {name: @API_KEY_ERROR_MESSAGE}