class Redass.Views.DashboardsView extends Backbone.View
  el: "body"
  events:
    'click .sidebar_namespace': 'viewNamespace'
    'click .sidebar_sub_namespace': 'viewSubNamespace'
    'click .namespace_key': 'viewKey'
    'click .delete_key': 'deleteKey'
    'click .delete_namespace': 'deleteNamespace'

  initialize: (options) ->
    @KeysCollection = new Redass.Collections.KeysCollection
    # @KeysCollection.fetch()

    # console.log "DashboardsView initialize!", options, this
    @NamespaceView = new Redass.Views.NamespaceView
      namespace: ""
      keys: @KeysCollection

    # console.log "DashboardsView initialized!", this

  render: ->
    # console.log "Rendering DashboardsView!", this
    @NamespaceView.render()

  viewNamespace: (e) ->
    # console.log "View Namespace clicked!"
    e.preventDefault()
    namespace = $(e.currentTarget).data "namespace"
    # console.log "Viewing namespace: #{namespace}"
    NamespaceView = new Redass.Views.NamespaceView
      namespace: namespace
      keys: @KeysCollection

    console.log "KeysCollection", @KeysCollection

    NamespaceView.render()

  viewSubNamespace: (e) ->
    e.preventDefault()
    # console.log "View Sub Namespace clicked!"
    namespace = $(e.currentTarget).data "namespace"
    # console.log "Viewing Sub Namespace: #{namespace}"
    SubNamespaceView = new Redass.Views.SubNamespaceView
      namespace: namespace
      keys: @KeysCollection
    SubNamespaceView.render()

  viewKey: (e) ->
    e.preventDefault()
    key = $(e.currentTarget).data 'key'
    console.log "Viewing key: #{key}", @KeysCollection.get key
    $key_viewer = $("#key_viewer_list")
    render_data = @KeysCollection.get(key).toJSON()
    switch render_data.type
      when "string" then render_data.isSingle = true
      when "set" then render_data.isSingle = false
      when "hash" then render_data.isSingle = false
      when "zset" then render_data.isSingle = false
      when "list" then render_data.isSingle = false

    $key_viewer.html HandlebarsTemplates['namespaces/key_viewer/item'] render_data

  deleteKey: (e) ->
    e.preventDefault()
    key = $(e.currentTarget).data 'key'
    console.log "Deleting key: #{key}"

    $.ajax
      method: "POST"
      url: '/keys/key'
      data:
        key: key
    .done (data) ->
      console.log  "DELETE Data: ", data
      if data.result == 1
        $("[data-key='#{key}']").remove()
    .fail (data) ->
      console.log "DELETE Fail:", data

  deleteNamespace: (e) ->
    e.preventDefault()
    namespace = $(e.currentTarget).data 'namespace'
    console.log "Deleting namespace: #{namespace}"

    $.ajax
      method: "POST"
      url: '/namespaces/delete'
      data:
        namespace: namespace
    .done (data) ->
      console.log "DELETE NAMESPACE Data: ", data
      selector = "[data-namespace='#{namespace}']"
      console.log "Testing selector #{selector}", $(selector)
      if data.result == 1
        $(selector).remove()
      else
        console.error "BAD ERROR CODE", data
    .fail (data) ->
      console.log "DELETE NAMESPACE Fail:", data
