describe "submitting a form", ->
  Given ->
    Backbone.history.stop()
    Hodor.start()
    @view = new Hodor.InvoiceRequest.Form.Views.RequestForm
    @$form = affix "form"
    @domEvent = new Object()
    @domEvent.preventDefault = -> ""
    @domEvent.currentTarget = @$form

  describe "should not submit if api key is empty or null", ->
    When ->
      @view.submitRequest(@domEvent)
      Then -> expect(@view.errors['apiKey']).toEqual("Please provide your API Key!")

  describe "should fetch data if api key is not empty", ->
    Given ->
      @$form.affix '#invoice-request-form input[name="apiKey"][value="123131"]'
      @eventSpy = sinon.spy()
      Hodor.commands.setHandler('timeEntries:requestData', @eventSpy)
    When -> @view.submitRequest(@domEvent)

    describe "there are no apiKey errors", ->
      Then -> expect(@view.errors).not.toContain('apiKey')
    describe "time entries are requested from ther server", ->
      Then -> expect(@eventSpy.called).toBe(true)
