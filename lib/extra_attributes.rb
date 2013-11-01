module ExtraAttributes
  def self.included(klass)
    klass.serialize :extra_attributes, Hash
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def extra_attributes(*attrs)
      attrs.each do |attr|
        #attr_accessible attr.to_sym
        define_method("#{attr}=") do |val|
          extra_attributes[attr] = block_given? ? yield(val) : val
          extra_attributes_will_change!
        end
        define_method(attr) do
          extra_attributes[attr]
        end
      end
    end
  end
end
