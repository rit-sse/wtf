require 'ri_cal'

class Event < ActiveRecord::Base
  validates_presence_of :name, :short_name
  validates_uniqueness_of :name

  has_many :event_prices
  belongs_to :committee

  mount_uploader :image, ImageUploader

  before_validation :generate_short_name

  private

  def generate_short_name
    if self.short_name.to_s == ""
      self.short_name = self.name
    end
  end

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
end
