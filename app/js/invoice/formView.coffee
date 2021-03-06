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
      @HOURLY_RATE_ERROR_MESSAGE = 'Please provide an hourly rate!'
      @START_DATE_ERROR_MESSAGE = 'Please provide a valid start date!'
      @END_DATE_ERROR_MESSAGE = 'Please provide a valid end date!'
      @END_DATE_AFTER_START_DATE_MESSAGE = 'End date has to be after start date!'

    submitRequest: (domEvent)->
      domEvent.preventDefault()
      form = $(domEvent.currentTarget)
      credentials = @_getCredentials(form)
      dates = @_getDates(form)
      hourlyRate = form.find(@HOURLY_RATE_INPUT).val()
      @validateForm credentials, hourlyRate, dates
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

    validateForm: (credentials, hourlyRate, dates) ->
      @errors = []
      @validateApiKey credentials.apiKey
      @validateName credentials.name
      @validateHourlyRate hourlyRate
      @validateDate dates.startDate, @START_DATE_ERROR_MESSAGE
      @validateDates dates

    validateName: (name) ->
      if !ValueValidator.isPresent(name)
        console.warn "Name is not present!"
        @errors.push {name: @NAME_ERROR_MESSAGE}

    validateApiKey: (apiKey)->
      if !ValueValidator.isPresent(apiKey)
        console.warn "API Key is not present!"
        @errors.push {name: @API_KEY_ERROR_MESSAGE}

    validateHourlyRate: (hourlyRate) ->
      if !ValueValidator.isPresent(hourlyRate)
        console.warn "Hourly Rate is not present!"
        @errors.push {name: @HOURLY_RATE_ERROR_MESSAGE}

    validateDate: (date, errorMessage) ->
      if !ValueValidator.isPresent(date) || !@_isValidDate(date)
        console.warn errorMessage
        @errors.push {name: errorMessage}
        return false
      return true

    validateDates: (dates) ->
      if @validateDate(dates.startDate, @START_DATE_ERROR_MESSAGE) && @validateDate(dates.endDate, @END_DATE_ERROR_MESSAGE)
        console.log "Check that end date is not before start date"
        if moment(dates.endDate, 'DD-MM-YYYY').dayOfYear() < moment(dates.startDate, 'DD-MM-YYYY').dayOfYear()
          console.warn "End date has to be after start date."
          @errors.push {name: @END_DATE_AFTER_START_DATE_MESSAGE}

    _isValidDate: (date) ->
      moment(date, 'DD-MM-YYYY').isValid()