class Redass.Views.SubNamespaceView extends Backbone.View
  el: '#sidebar_sub_namespaces_list'
  template: 'namespaces/sidebar_list_item'

  initialize: (options) ->
    console.log "initialize SUB NamespaceView", options
    @keys = options.keys

    self = this
    $viewer_keys = $ "#namespace_viewer_keys"

    @namespaces = new Redass.Collections.NamespacesCollection
      namespace: options.namespace
      keys: @keys

    @namespaces.on 'sync', ->
      # console.log "Sub Namespaces synced!", this
      self.$el.html ""
      $viewer_keys.html ""
      this.each (namespace) ->
        # console.log "Parsing/rendering sub namespace! ", namespace.toJSON()
        # console.log "Namespace url: #{namespace.url()}"
        self.$el.append HandlebarsTemplates[self.template] namespace.toJSON()

        namespace_key = self.keys.get(namespace.get("name"))
        console.log "Namespace key?", namespace_key
        if namespace_key
          $viewer_keys.append HandlebarsTemplates['namespaces/viewer/item'] namespace_key.toJSON()
        _.each namespace.get("keys"), (key) ->
          $viewer_keys.append HandlebarsTemplates['namespaces/viewer/item'] key


  render: (sub_namespace) ->
    # console.log "render SubNamespaceView", sub_namespace
    @namespaces.fetch()
