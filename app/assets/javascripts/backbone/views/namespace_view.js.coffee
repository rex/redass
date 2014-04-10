class Redass.Views.NamespaceView extends Backbone.View
  el: '#sidebar_namespaces_list'
  template: 'namespaces/sidebar_list_item'

  initialize: (options) ->
    console.log "initialize NamespaceView", options

    self = this
    @namespaces = new Redass.Collections.NamespacesCollection
      namespace: options.namespace
      keys: options.keys

    @namespaces.on 'sync', ->
      # console.log "Namespaces synced!", this
      this.each (namespace) ->
        # console.log "Parsing/rendering namespace! ", namespace.toJSON()
        # console.log "Namespace url: #{namespace.url()}"
        self.$el.append HandlebarsTemplates[self.template] namespace.toJSON()

    @initViewer()

  render: ->
    # console.log "render NamespaceView", this
    @namespaces.fetch()

  initViewer: ->
    $("#namespace_viewer").html HandlebarsTemplates['namespaces/viewer/main']()
    $("#key_viewer").html HandlebarsTemplates['namespaces/key_viewer/main']()
