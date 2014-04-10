$ ->
  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify obj, null, 2