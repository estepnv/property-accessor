# frozen_string_literal: true

module PropertyAccessor
  class PropertyBuilder

    # @param property [PropertyAccessor::Property]
    def initialize(property)
      @property = property
    end

    def default(value = nil, &block)
      if value
        @property.default_value = value
      else
        @property.default_value_proc = block
      end
    end

    def get(&block)
      if block
        @property.getter_proc = block
      else
        @property.default_getter = true
      end
    end

    def set(&block)
      if block
        @property.setter_proc = block
      else
        @property.default_setter = true
      end
    end
  end
end
