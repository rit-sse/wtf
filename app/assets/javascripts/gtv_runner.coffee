
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

  matchesStartDate: (datetime) ->
    otherDate = datetime.clearTime()
    thisDate = Date.parseExact(this.startDate(), "yyyy-MM-ddTHH:mm:ss-05:00").clearTime()
    return thisDate.equals(otherDate)

# Make new events right in the browser with:
# newEvent = new SSEEvent

class SSETwoWeekView extends Backbone.View
  initialize: ->
    # alert("Name: " + @options.events[0].get("name"))
    $("body").html(JST["templates/two_week_view"]( events: @options.events, date: @options.date ))

class SSEMonthView extends Backbone.View
  initialize: ->
    # alert("Name: " + @options.events[0].get("name"))
    $("body").html(JST["templates/month_view"]( events: @options.events, date: @options.date ))

class SSEBlankView extends Backbone.View
  initialize: ->
    # alert("Blanking out screen.")
    $("body").html("")

class SSEController extends Backbone.Router
  pageSettings =
    "month":
      "timeAlive": 20
      "nextPage": "two_week"
    "two_week":
      "timeAlive": 20
      "nextPage": "month"
    "blank":
      "timeAlive": 1
      "nextPage": "upcoming"
    "upcoming":
      "timeAlive": 1
      "nextPage": "month"
  routes:
    "../events/:id": "month"

  start: =>
    this.month()
    @countdown = pageSettings.month.timeAlive
    @page = "month"
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
      when "upcoming" then @upcoming()
      when "two_week" then @two_week()
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

  upcoming: ->
    req =
      limit: 2
    $.getJSON '../events', req, (data) ->
      new SSEBlankView

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
