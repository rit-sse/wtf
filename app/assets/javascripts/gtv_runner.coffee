
SSE  = {}

class SSE.Event extends Backbone.Model
  url: ->
    base = 'events'
    base + @id

// Make new events right in the browser with:
// newEvent = new SSE.Event

$ ->
  $("body").html(JST["templates/month_view"]({name : "Sam"}))

