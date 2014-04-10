class Redass.Routers.NamespacesRouter extends Backbone.Router
  initialize: (options) ->
    # console.log "initialize NamespacesRouter", options

  routes:
    "namespaces/:namespace": "viewNamespace"

  viewNamespace: (namespace) ->
    # console.log "Viewing namespace: #{namespace}"


