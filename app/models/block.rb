class Block < ActiveRecord::Base

  attr_accessible :content
  attr_accessible :section_key
  attr_accessible :type

  belongs_to :page

  def section_key
    section_key_attr = read_attribute(:section_key)
    section_key_attr.to_sym if section_key_attr
  end

  def extra_attributes(*attributes)
    attrs.each do |attr|
      define_method("#{attr}=") do |val|
        extra_attributes[attr] = val
        extra_attributes_will_change!
      end
      define_method(attr) do
        extra_attributes[attr]
      end
    end
  end

  def self.partial_name
    self.name.demodulize.underscore
  end

end
