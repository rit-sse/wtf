# validate uniqueness of slug within a page's siblings
class SlugUniquenessValidator < ActiveModel::Validator
  def validate(record)
    siblings = record.siblings.where(slug: record.slug).to_a
    record.errors[:slug] << "is already taken" unless siblings.empty?
  end
end

class Page < ActiveRecord::Base
  include ActiveSupport::Inflector

  has_ancestry

  validates_presence_of :title, :slug
  validates_format_of :slug, :with => /^[a-zA-Z0-9\-_]+$/
  validates_with SlugUniquenessValidator
end
