do (Backbone) ->

  # Add utility functions to Marionette.Application.
  _.extend Backbone.Marionette.Application::,

    navigate: (route, options = {}) ->
      Backbone.history.navigate route, options

    getCurrentRoute: ->
      frag = Backbone.history.fragment
      if _.isEmpty(frag) then null else frag
      #location.pathname

    startHistory: ->
      if Backbone.history
      	Backbone.history.start silent:true
        #Backbone.history.start({pushState: true})

