
class SSEEvent extends Backbone.Model
  url: ->
    base = 'events'
    base + @id

# Make new events right in the browser with:
# newEvent = new SSEEvent

class SSEMonthView extends Backbone.View
  initialize: ->
    # alert("Name: " + @options.events[0].get("name"))
    $("body").html(JST["templates/month_view"]( events: @options.events ))

class SSEController extends Backbone.Router
  routes:
    "../events/:id": "month"
  month: ->
    $.getJSON '../events', (data) ->
      if data
        allEvents = _(data).map (event) ->
          new SSEEvent(event)
        new SSEMonthView events: allEvents
      else
        alert("Warning: no events to load!")

# Make new controller with:
# newCont = new SSEController
# newCont.month()

# Use this to create stuff from eco templates
# $ ->
#  $("body").html(JST["templates/month_view"]({name : "Sam"}))

app = new SSEController
Backbone.history.start()

# app.navigate "month", trigger: true
app.month()
