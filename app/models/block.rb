class Block < ActiveRecord::Base

  belongs_to :page

  # Allows subclasses of Block to add extra data attributes to the model
  # ex: declaring 'extra_attributes :foo' in a subclass adds a new 'foo'
  # attribute to the model.
  include ExtraAttributes

  # Gets a symbol representing the page section the
  # block is associated with
  def section_key
    section_key_attr = read_attribute(:section_key)
    section_key_attr.to_sym if section_key_attr
  end

  def self.partial_name
    self.name.demodulize.underscore
  end

  # Allows subclasses to be instantiated when new is called with a type
  # parameter. ex: Block.new(:type => 'Markdown') instantiates a markdown
  # block.
  #   Code snippet from http://coderrr.wordpress.com/2008/04/22/building-the-right-class-with-sti-in-rails/
  class << self
    def new_with_cast(*attributes, &block)
      if (h = attributes.first).is_a?(Hash) && !h.nil? &&(type = h[:type] || h['type']) && type.length > 0 && (klass = type.constantize) != self
        raise "Unable to create new object with cast"  unless klass <= self
        return klass.new(*attributes, &block)
      end

      new_without_cast(*attributes, &block)
    end
    alias_method_chain :new, :cast

  end

  private

  # Sets the type attribute as unprotected which allows the block type to be
  # specified during mass assignment
  def self.attributes_protected_by_default
    super - [inheritance_column]
  end

end
