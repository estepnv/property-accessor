require 'property_accessor/class_methods.rb'
require 'property_accessor/property_builder.rb'
require 'property_accessor/property.rb'

module PropertyAccessor
  include ClassMethods

  module Mixin
    def self.inject!
      Class.include(ClassMethods)
    end
  end
end
