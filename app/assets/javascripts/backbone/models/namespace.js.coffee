class Redass.Models.Namespace extends Backbone.Model
  idAttribute: 'name'

class Redass.Collections.NamespacesCollection extends Backbone.Collection
  model: Redass.Models.Namespace
  url: '/namespaces'
  initialize: (options) ->
    # console.log "NamespacesCollection options", options, this
    this.url = "#{this.url}/#{options.namespace}"
    # console.log "NamespacesCollection URL updated: #{this.url}"

    KeysCollection = options.keys

    this.on 'sync', ->
      this.each (namespace) ->
        KeysCollection.add namespace.get "keys"
        # _.each namespace.get("keys"), (key) ->
        #   KeysCollection.add key

      console.log "KeysCollection updated", KeysCollection
