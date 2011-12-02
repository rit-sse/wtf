class Page < ActiveRecord::Base
  include ActiveSupport::Inflector

  has_ancestry
  validates_presence_of :title, :slug
  validates_format_of :slug, :with => /^[a-zA-Z0-9\-_]+$/
end
