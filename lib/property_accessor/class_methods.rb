# frozen_string_literal: true

module PropertyAccessor
  UndefinedPropertyError = Class.new(StandardError)

  module ClassMethods
    def property(property_name, &block)
      property = Property.new(property_name)
      builder = PropertyBuilder.new(property)

      if block.nil?
        raise UndefinedPropertyError, 'cannot define a property without specifying at least getter or setter'
      end

      builder.instance_exec(&block)

      define_method(property.initializer_method_name) do
        if !instance_variable_defined?(property.field_name)
          instance_variable_set(
            property.field_name,
            property.default_value_proc ?
              instance_exec(&property.default_value_proc) :
              property.default_value
          )
        end
      end

      private property.initializer_method_name

      if property.getter_defined?
        define_method(property.getter_method_name) do
          send(property.initializer_method_name)
          instance_exec(&property.getter_proc)
        end
      elsif property.default_getter
        define_method(property.getter_method_name) do
          send(property.initializer_method_name)
          instance_variable_get(property.field_name)
        end
      end

      if property.setter_defined?
        define_method(property.setter_method_name, property.setter_proc)
      elsif property.default_setter
        define_method(property.setter_method_name) do |val|
          instance_variable_set(property.field_name, val)
        end
      end

      property.private_method_names.each do |method_name|
        private method_name
      end

      property.protected_method_names.each do |method_name|
        protected method_name
      end

      property.public_method_names.each do |method_name|
        public method_name
      end
    end
  end
end

