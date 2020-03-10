# frozen_string_literal: true

module PropertyAccessor
  class Property

    attr_accessor :value, :setter_proc, :getter_proc

    def initialize(name)
      @name = name
      @setter_proc = nil
      @getter_proc = nil
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
