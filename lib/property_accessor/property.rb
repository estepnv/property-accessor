# frozen_string_literal: true

module PropertyAccessor
  class Property

    attr_accessor :name,
                  :value,
                  :setter_proc,
                  :getter_proc,
                  :default_getter,
                  :default_setter,
                  :default_value,
                  :default_value_proc

    def initialize(name)
      @name = name
      @setter_proc = nil
      @getter_proc = nil
      @default_getter = false
      @default_setter = false
      @default_value = nil
      @default_value_proc = nil
      @value = nil
    end

    def setter_defined?
      !@setter_proc.nil?
    end

    def getter_defined?
      !@getter_proc.nil?
    end
  end
end
