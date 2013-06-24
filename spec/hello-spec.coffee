describe "time rounder returns true for period of time that is factor if 15 minutes", ->
  When -> @fifteenMinutes = 15
  Then -> expect(TimeRounder.isFactorOf15(@fifteenMinutes)).toEqual(true)

describe "returns false for time that is not a factor of 15 minutes", ->
  When -> @fiftyFiveMinutes = 55
  Then -> expect(TimeRounder.isFactorOf15(@fiftyFiveMinutes)).toEqual(false)

describe "rounds off time to next 15 minute mark if is not factor of 15", ->
  When -> @fiftyFiveMinutes = 55
  Then -> expect(TimeRounder.roundOff(@fiftyFiveMinutes)).toEqual(60)

describe "returns same time if it is a factor of 15", ->
  When -> @halfAnHour = 180
  Then -> expect(TimeRounder.roundOff(@halfAnHour)).toEqual(@halfAnHour)


describe "backbone models", ->
  Given -> Backbone.history.stop()
  And -> Hodor.start()
  describe "mucking with the models", ->
    When -> @timeEntry = new Hodor.InvoiceRequest.Form.Models.TimeEntry(duration: 200)
    Then ->  expect(@timeEntry.get('duration')).toEqual(200)

  context "mucking around with the collections", ->
    When -> @entries = [{duration: 180}, {duration: 360}]
    And -> @timeEntries = new Hodor.InvoiceRequest.Form.Models.TimeEntries @entries
    Then -> expect(@timeEntries.size()).toEqual(2)

  context "should add all the time entries in a collection", ->
    When -> @entries = [{duration: 1800}, {duration: 3600}]
    And -> @timeEntries = new Hodor.InvoiceRequest.Form.Models.TimeEntries @entries
    Then -> expect(@timeEntries.sumOfDurations()).toEqual(90)

  context "sum of durations should round off times", ->
    When -> @entries = [{duration: 1801}, {duration: 3601}]
    And -> @timeEntries = new Hodor.InvoiceRequest.Form.Models.TimeEntries @entries
    Then ->expect(@timeEntries.sumOfDurations()).toEqual(120)

  context "should only sum billable entries", ->
    When -> @entries = [{duration: 1801, billable: true}, {duration: 3601, billable: true}, {duration: 4000, billable: false}]
    And -> @timeEntries = new Hodor.InvoiceRequest.Form.Models.TimeEntries @entries
    Then -> expect(@timeEntries.sumOfBillableTime()).toEqual(120)

  context "should calculate the billableAmount", ->
    When -> @entries = [{duration: 1801}, {duration: 3601}]
    And -> @timeEntries = new Hodor.InvoiceRequest.Form.Models.TimeEntries @entries
    And -> @timeEntrySummary = new Hodor.InvoiceRequest.Form.Models.TimeEntrySummary {hourlyRate: 25, totalTime: @timeEntries.sumOfDurations()}
    And -> @timeEntrySummary.setBillableAmount()
    Then -> expect(@timeEntrySummary.get('billableAmount')).toEqual(50)