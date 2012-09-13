module EventsHelper

  def format_datetime_short(event)
    # Construct the first time format
    format_start = "%-m/%d %l"
    format_start += ":%M" unless event.start_date.min == 0

    # Only show the am/pm indicator if it is different for the end date
    if (event.start_date.to_date != event.end_date.to_date) or
       ((0..11).include?(event.start_date.hour) != (0..11).include?(event.start_date.hour))

      format_start += " %P"
    end

    # Construct the second time format
    format_end = ""
    if (event.start_date.to_date != event.end_date.to_date)
      # Show the date again if the dates are different
      format_end += "%-m/%d "
    end
    format_end += "%l"
    format_end += ":%M" unless event.end_date.min == 0
    format_end += " %P"

    return event.start_date.strftime(format_start) + " - " + event.end_date.strftime(format_end)
  end

end
