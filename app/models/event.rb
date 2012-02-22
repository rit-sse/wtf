class Event < ActiveRecord::Base
  validates :name, :presence => true
  validates_uniqueness_of :name

  has_many :event_prices
  belongs_to :committee

end
