# validate uniqueness of slug within a page's siblings
class SlugUniquenessValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record?
      siblings = record.siblings.where(slug: record.slug).to_a
      record.errors[:slug] << "is already taken" unless siblings.empty?
    end
  end
end

class Page < ActiveRecord::Base
  include ActiveSupport::Inflector

  has_many :blocks, :dependent => :destroy
  has_ancestry

  accepts_nested_attributes_for :blocks, :allow_destroy => true

  validates_presence_of :title, :slug, :layout
  validates_format_of :slug, :with => /^[a-zA-Z0-9\-_]+$/
  validates_with SlugUniquenessValidator
  validates_associated :blocks

  # callbacks
  before_validation :generate_slug

  def path
    '/' + (self.ancestors + [self]).collect(&:slug).join('/').to_s
  end

  def self.get_pages_tree(parent_id=nil, level=0)
    pages_tree = []

    pages = (parent_id.nil? ? Page.roots : Page.children_of(parent_id)).order("title")

    pages.each do |page|
      spacer = (("-" * level) + " " || "")
      pages_tree << [spacer + page.title, page.id]
      pages_tree += Page.get_pages_tree(page.id, level+1)
    end

    pages_tree
  end

  def layout
    layout_class = read_attribute(:layout)
    layout_class.is_a?(String) ? Kernel.const_get(layout_class.classify) : layout_class
  end

  def sections
    @sections ||= layout ? layout.build_sections(self) : []
  end

  def section(key)
    sections.find { |s| s.key == key } ||
      raise(Error.new("#{layout.title} pages do not have a section called '#{key}'"))
  end

protected

  def generate_slug
    if self.slug.to_s == ""
      safe_slug = parameterize self.title
      generated = safe_slug
      counter = 0

      while true
        siblings = self.siblings.where(slug: generated).to_a
        break if siblings.empty?
        counter += 1
        generated = "#{safe_slug}#{counter}"
      end

      self.slug = generated
    else
      # intentionally downcase the slug
      self.slug.downcase!
    end
  end

end
