# frozen_string_literal: true

module PropertyAccessor
  UndefinedPropertyError = Class.new(StandardError)

  module ClassMethods
    def property(property_name, &block)
      property = Property.new(property_name)
      builder = PropertyBuilder.new(property)

      if block.nil?
        raise UndefinedPropertyError, 'cannot define a proprty without specifing at least getter or setter'
      end

      builder.instance_exec(&block)

      if property.getter_defined?
        define_method(property_name, property.getter_proc)
      end

      if property.setter_defined?
        define_method("#{property_name}=", property.setter_proc)
      end

    end
  end
end

