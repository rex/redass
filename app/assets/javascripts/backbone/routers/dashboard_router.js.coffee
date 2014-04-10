class Redass.Routers.DashboardsRouter extends Backbone.Router
  initialize: (options) ->
    console.log "DashboardsRouter initialize!"
  routes:
    "keys(/?)": "keys"
    "(/?)": "index"

  index: ->
    # console.log "Index route!", this
    DashboardsView = new Redass.Views.DashboardsView
    DashboardsView.render()

  keys: ->
    # console.log "Keys route!", this

