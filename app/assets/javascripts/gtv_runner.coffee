
SSEHelpers =
  getLastSunday: ->
    date = Date.today()
    if not date.is().sunday()
      date = date.last().sunday()
    return date

class SSEEvent extends Backbone.Model
  url: ->
    base = 'events'
    base + @id

  shortName: ->
    this.get("short_name")

  startDate: ->
    this.get("start_date")

  startDay: ->
    dt = this.parseDateTime(this.startDate())
    dt.toString("MMMM d")

  startHour: ->
    dt = this.parseDateTime(this.startDate())
    dt.toString("htt")

  location: ->
    this.get("location")

  matchesStartDate: (datetime) ->
    otherDate = datetime.clearTime()
    thisDate = this.parseDateTime(this.startDate()).clearTime()

    return thisDate.equals(otherDate)

  parseDateTime: (datetime) ->
    retDate = Date.parseExact(datetime, "yyyy-MM-ddTHH:mm:ss-05:00")
    if not retDate
      retDate = Date.parseExact(datetime, "yyyy-MM-ddTHH:mm:ss-04:00")

    if not retDate
      console.log("ERROR: no known timezone for server.")

    return retDate


class SSEThreeWeekView extends Backbone.View
  initialize: ->
    $("body").html(JST["templates/three_week_view"]( events: @options.events, date: @options.date ))

class SSETwoWeekView extends Backbone.View
  initialize: ->
    $("body").html(JST["templates/two_week_view"]( events: @options.events, date: @options.date ))

class SSEMonthView extends Backbone.View
  initialize: ->
    $("body").html(JST["templates/month_view"]( events: @options.events, date: @options.date ))

class SSEEventPanelsView extends Backbone.View
  initialize: ->
    $("body").html(JST["templates/15_event_view"]( events: @options.events ))

class SSEBlankView extends Backbone.View
  initialize: ->
    # alert("Blanking out screen.")
    $("body").html("")

class SSEController extends Backbone.Router
  pageSettings =
    "three_week":
      # Refresh every three minutes
      "timeAlive": 30
      "nextPage": "event_panels"
    "event_panels":
      "timeAlive": 30
      "nextPage": "three_week"
    "month":
      "timeAlive": 0
      "nextPage": "two_week"
    "two_week":
      "timeAlive": 20
      "nextPage": "month"
    "blank":
      "timeAlive": 1
      "nextPage": "blank"
  routes:
    "../events/:id": "month"

  start: =>
    #this.three_week()
    #@countdown = pageSettings.three_week.timeAlive
    #@page = "three_week"
    this.event_panels()
    @countdown = pageSettings.event_panels.timeAlive
    @page = "event_panels"
    @timerId = setInterval(this.flipPage, 1000)

  flipPage: =>
    if @countdown == -1
      @page = pageSettings[@page].nextPage
      @gotoPage(@page)
      @countdown = pageSettings[@page].timeAlive
    @countdown = @countdown - 1

  gotoPage: (page) =>
    switch page
      when "month" then @month()
      when "two_week" then @two_week()
      when "three_week" then @three_week()
      when "event_panels" then @event_panels()
      else @pause()

  month: =>
    sundayStart = SSEHelpers.getLastSunday()
    $.getJSON '../events', start_date: sundayStart.toISOString(), (data) ->
      if data
        allEvents = _(data).map (event) ->
          new SSEEvent(event)
        new SSEMonthView 
          events: allEvents 
          date: sundayStart 
      else
        alert("Warning: no events to load!")

  two_week: =>
    sundayStart = SSEHelpers.getLastSunday()
    $.getJSON '../events', start_date: sundayStart.toISOString(), (data) ->
      if data
        allEvents = _(data).map (event) ->
          new SSEEvent(event)
        new SSETwoWeekView 
          events: allEvents 
          date: sundayStart
      else
        alert("Warning: no events to load!")

  three_week: =>
    sundayStart = SSEHelpers.getLastSunday()
    $.getJSON '../events', start_date: sundayStart.toISOString(), (data) ->
      if data
        allEvents = _(data).map (event) ->
          new SSEEvent(event)
        new SSEThreeWeekView 
          events: allEvents 
          date: sundayStart
      else
        alert("Warning: no events to load!")

  event_panels: =>
    req = 
      limit: 12 
    $.getJSON '../events', req, (data) ->
      if data
        allEvents = _(data).map (event) ->
          new SSEEvent(event)
        new SSEEventPanelsView
          events: allEvents
      else
        console.log("No events to load.");

  pause: ->
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
