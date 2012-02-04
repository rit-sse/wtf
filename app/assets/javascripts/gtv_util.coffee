
window.SSEDateParse = (datetime) ->
  return Date.parseExact(datetime, "yyyy-MM-ddTHH:mm:ss-05:00").clearTime()

window.SSEDateCheck = (univTime, date) ->
  eventDate = Date.parseExact(univTime, "yyyy-MM-ddTHH:mm:ss-05:00").clearTime()
  return date.equals(eventDate)

