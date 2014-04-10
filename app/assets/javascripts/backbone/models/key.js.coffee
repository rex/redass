class Redass.Models.Key extends Backbone.Model
  idAttribute: "name"

class Redass.Collections.KeysCollection extends Backbone.Collection
  model: Redass.Models.Key
  url: '/keys'

  initialize: (options) ->

    this.on 'sync', ->
      $key_viewer = $("#namespace_viewer_keys")
      $key_viewer.html ""

      groups = this.groupBy (key) ->
        key.get("name").split(":")[0]

      console.log "Groups", groups

      _.each groups, (group) ->
        sub_groups = _.groupBy group, (key) ->
          parts = key.get("name").split(":")
          "#{parts[0]}:#{parts[1]}"
        console.log "Sub Groups", sub_groups

        _.each sub_groups, (sub_group) ->
          sub_sub_groups = _.groupBy sub_group, (key) ->
            parts = key.get("name").split(":")
            if parts.length >= 3
              "#{parts[0]}:#{parts[1]}:#{parts[2]}"
            else
              "#{parts[0]}:#{parts[1]}"
          console.log "Sub Sub groups", sub_sub_groups

      # this.each (key) ->
      #   $key_viewer.append HandlebarsTemplates['namespaces/viewer/key'] key.toJSON()
