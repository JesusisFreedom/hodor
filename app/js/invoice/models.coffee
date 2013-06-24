@Hodor.module "InvoiceRequest.Form.Models", (Models, App, Backbone, Marionette, $, _ ) ->

  class Models.TimeEntry extends App.Entities.Model
    defaults:
      duration: 0

  class Models.TimeEntries extends App.Entities.Collection
    model: Models.TimeEntry
    url: ->
      "/time_entries/#{@apiKey}?start_date=#{@startDate}&end_date=#{@endDate}"

    initialize: (apiKey, startDate, endDate)->
      @apiKey = apiKey
      @startDate = startDate
      @endDate = endDate

    sumOfDurations: ->
      @_addTimeFor @models

    sumOfBillableTime: ->
      billableEntries = (model for model in @models when model.get('billable') == true)
      @_addTimeFor billableEntries

    _addTimeFor: (timeEntries) ->
      timeEntries.reduce (x, y) ->
        x + TimeRounder.roundOff(y.get('duration')/60)
      ,0

    class Models.TimeEntrySummary extends App.Entities.Model
      defaults:
        totalTime: 0

      inititalize: (options = {}) ->
        @set 'hourlyRate', options.hourlyRate
        @set 'totalTime', options.totalTime
        @setPrintableDates()

      setBillableAmount: ->
        @set 'billableAmount', @calculateBillableAmount()

      calculateBillableAmount: ->
        @get('hourlyRate') * (@get('totalTime')/60)

      setPrintableDates: ->
        @_setPrintableStartDate()
        @_setPrintableEndDate()

      _setPrintableStartDate: ->
        startDate = @get 'startDate'
        @set('printableStartDate', startDate.format('DD MMM YYYY'))

      _setPrintableEndDate: ->
        endDate = @get 'endDate'
        @set('printableEndDate', endDate.format('DD MMM YYYY'))


  API =
    fetch: (apiKey, startDate, endDate) ->
      timeEntries = new Models.TimeEntries apiKey, startDate, endDate
      timeEntries.fetch reset: true
      timeEntries

    getSummary: (options) ->
      summary = new Models.TimeEntrySummary
        name:       options.name
        hourlyRate: options.hourlyRate
        totalTime:  options.totalTime
        startDate:  options.dates.startDate
        endDate:    options.dates.endDate
      summary.setBillableAmount()
      summary.setPrintableDates()
      summary


  App.reqres.setHandler "timeEntries:fetch", (apiKey, startDate, endDate) ->
    API.fetch apiKey, startDate, endDate

  App.reqres.setHandler "timeEntries:getSummary", (options) ->
    API.getSummary options

