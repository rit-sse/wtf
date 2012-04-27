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
end
