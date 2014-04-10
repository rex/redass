$ ->
  new Redass.Routers.DashboardsRouter
  new Redass.Routers.NamespacesRouter

  console.log "Init!", Redass

  Backbone.history.start pushState: true