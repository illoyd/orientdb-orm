module Orientdb
  module ORM

    ##
    # TODO: Convert to a struct
    class AttributeDefinition
      attr_accessor :name, :accessor, :field_type, :default, :validates_options
      
      def initialize(name, field_type = nil, options = {})
        @name              = name.to_s
        @accessor          = options[:accessor] || name
        @field_type        = field_type
        @default           = options[:default]   || nil
        @validates_options = options[:validates] || {}
      end
    end

  end
end
