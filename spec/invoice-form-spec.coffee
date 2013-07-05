describe "submitting a form", ->
  #Given -> Hodor.start()
  Given -> @view = new Hodor.InvoiceRequest.Form.Views.RequestForm
  And ->
    @domEvent = new Object()
    @domEvent.preventDefault = -> ""
  describe "should not submit if api key is empty or null", ->
    When -> @view.submitRequest(@domEvent)
    Then -> expect(@view.errors['apiKey']).toEqual("Please provide your API Key!")