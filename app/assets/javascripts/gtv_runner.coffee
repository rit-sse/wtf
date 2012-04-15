
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

class SSEEventPanelsView extends Backbone.View
  initialize: ->
    $("body").html(JST["templates/15_event_view"]( events: @options.events ))

class SSEColorView extends Backbone.View
  initialize: ->
    $("body").html(JST["templates/color_view"]( color: @options.color ))

class SSEController extends Backbone.Router
  pageSettings =
    "three_week":
      # Refresh every three minutes
      "timeAlive": 30
      "nextPage": "black_view"
    "event_panels":
      "timeAlive": 30
      "nextPage": "white_view"
    "black_view":
      "timeAlive": 5
      "nextPage": "event_panels"
    "white_view":
      "timeAlive": 5
      "nextPage": "three_week"
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
      when "three_week" then @three_week()
      when "event_panels" then @event_panels()
      when "black_view" then @black_view()
      when "white_view" then @white_view()
      else @black_view()

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

  white_view: =>
    new SSEColorView
      color: "white"

  black_view: =>
    new SSEColorView
      color: "black"

app = new SSEController
Backbone.history.start()

# app.navigate "month", trigger: true
app.start()
