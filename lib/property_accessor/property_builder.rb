# frozen_string_literal: true

module PropertyAccessor
  class PropertyBuilder

    private
    attr_reader :property

    public

    # @param property [PropertyAccessor::Property]
    def initialize(property)
      @property = property
    end

    def default(value = nil, &block)
      if value
        property.default_value = value
      else
        property.default_value_proc = block
      end
    end

    def private(method_name)
      property.private_method_names << method_name
    end

    def protected(method_name)
      property.protected_method_names << method_name
    end

    def public(method_name)
      property.public_method_names << method_name
    end

    # @param method_name [String, Symbol] override getter method name
    def get(method_name = nil, &block)
      if method_name
        property.getter_method_name = method_name
      end

      if block
        property.getter_proc = block
      else
        property.default_getter = true
      end

      @property.getter_method_name
    end

    # @param method_name [String, Symbol] override setter method name
    def set(method_name = nil, &block)
      if method_name
        property.setter_method_name = method_name
      end

      if block
        property.setter_proc = block
      else
        property.default_setter = true
      end

      property.setter_method_name
    end
  end
end
