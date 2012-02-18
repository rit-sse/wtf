
class SSEEvent extends Backbone.Model
  url: ->
    base = 'events'
    base + @id

  startDate: ->
    this.get("start_date")

  matchesStartDate: (datetime) ->
    otherDate = datetime.clearTime()
    thisDate = Date.parseExact(this.startDate(), "yyyy-MM-ddTHH:mm:ss-05:00").clearTime()
    return thisDate.equals(otherDate)

# Make new events right in the browser with:
# newEvent = new SSEEvent

class SSEMonthView extends Backbone.View
  initialize: ->
    # alert("Name: " + @options.events[0].get("name"))
    $("body").html(JST["templates/month_view"]( events: @options.events, date: @options.date ))

class SSEBlankView extends Backbone.View
  initialize: ->
    # alert("Blanking out screen.")
    $("body").html("")

class SSEController extends Backbone.Router
  routes:
    "../events/:id": "month"
  start: =>
    this.month()
    @countdown = 10
    @page = "month"
    @timerId = setInterval(this.flipPage, 1000)
  flipPage: =>
    # console.log("flipPage()")
    if @countdown == 0
      console.log("Done counting down.")
      if @page == "month"
        this.pause()
        @page = "blank"
      else
        this.month()
        @page = "month"
      @countdown = 10
    else
      # console.log("Countdown before: " + @countdown)
      @countdown = @countdown - 1
      # console.log("Countdown after: " + @countdown)
  month: =>
    $.getJSON '../events', (data) ->
      if data
        allEvents = _(data).map (event) ->
          new SSEEvent(event)
        startingDate = Date.today()
        if not startingDate.is().monday()
          startingDate = startingDate.last().monday()
        new SSEMonthView 
          events: allEvents 
          date: startingDate
      else
        alert("Warning: no events to load!")
  pause: ->
    # alert("Pausing")
    new SSEBlankView

# Make new controller with:
# newCont = new SSEController
# newCont.month()

# Use this to create stuff from eco templates
# $ ->
#  $("body").html(JST["templates/month_view"]({name : "Sam"}))

app = new SSEController
Backbone.history.start()

# app.navigate "month", trigger: true
app.start()
