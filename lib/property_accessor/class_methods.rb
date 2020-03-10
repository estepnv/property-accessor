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

      define_method("initialize_#{property.name}") do
        if !instance_variable_defined?("@#{property.name}")
          instance_variable_set(
            "@#{property.name}",
            property.default_value_proc ?
              instance_exec(&property.default_value_proc) :
              property.default_value
          )
        end
      end

      private "initialize_#{property.name}"

      if property.getter_defined?
        define_method(property.name) do
          send("initialize_#{property.name}")
          instance_exec(&property.getter_proc)
        end
      end

      if property.setter_defined?
        define_method("#{property.name}=", property.setter_proc)
      end

      if property.default_getter
        define_method(property.name) do
          send("initialize_#{property.name}")
          instance_variable_get("@#{property.name}")
        end
      end

      if property.default_setter
        attr_writer property.name
      end

    end
  end
end

