@Hodor = do(Backbone, Marionette) ->

  App = new Marionette.Application()

  App.addRegions
    mainRegion:'#main-region'
    messagesRegion:'#messages-region'

  App.reqres.setHandler "default:region", ->
    App.mainRegion

  App.addInitializer ->
    App.module('Router').start()

  App.on "initialize:after", ->
    @startHistory()
    console.log "current route: ", App.getCurrentRoute()
    @navigate('/index', trigger: true) #unless App.getCurrentRoute()

  App