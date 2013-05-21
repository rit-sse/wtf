require 'ri_cal'
require 'csv'

class Event < ActiveRecord::Base
  validates_presence_of :name, :short_name, :location, :committee
  validates :short_name, :length => { minimum: 1,  maximum: 25 }

  has_many :event_prices
  belongs_to :committee

  mount_uploader :image, ImageUploader

  ##
  # Returns the week of the event in a hash of the format:
  # {:start_day => <Sunday, 0:00:00 of the week>, 
  #  :end_day   => <Saturday, 12:59:59 of the week>}
  #
  # Weeks are currently defined to start on sundays
  #
  # Can be used like: @events.group_by(&:week)
  # (See the index for events controler/view)
  def week
    start_date = self.start_date.change({:hour => 0, :min => 0, :sec => 0})
    end_date = self.end_date.change({:hour => 23, :min => 59, :sec => 59})

    while !start_date.sunday?
      start_date -= 1.day
    end

    while !end_date.saturday?
      end_date += 1.day
    end

    return {start_day: start_date, end_day: end_date}
  end

  private

  def Event.to_ical
    RiCal.Calendar do |cal|
      Event.all.each do |model_event|
        cal.event do |ical_event|
          ical_event.summary     = model_event.short_name
          ical_event.description = model_event.description
          ical_event.dtstart     = model_event.start_date
          ical_event.dtend       = model_event.end_date
          ical_event.location    = model_event.location
        end
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      line = []
      line << "Short Name"
      line << "Committee"
      line << "Name"
      line << "Start"
      line << "End"
      csv << line
      all.each do |event|
        line = []
        line << event.short_name
        line << event.committee.name
        line << event.name
        line << event.start_date.to_s
        line << event.end_date.to_s
        csv << line
      end
    end
  end


end
