# frozen_string_literal: true

module PropertyAccessor
  class PropertyBuilder

    # @param property [PropertyAccessor::Property]
    def initialize(property)
      @property = property
    end

    def get(&block)
      @property.getter_proc = block
    end

    def set(&block)
      @property.setter_proc = block
    end
  end
end
