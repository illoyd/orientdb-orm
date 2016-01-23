module Orientdb
  module ORM

    ##
    # TODO: Convert to a struct
    class AttributeDefinition
      attr_accessor :name, :accessor, :type, :default, :validates_options

      def initialize(name, type = :value, options = {})
        @name              = name.to_s
        @accessor          = options[:accessor] || name
        @type              = self.class.coerce_type(type)
        @default           = options[:default]
        @validates_options = options[:validates]
      end

      def self.coerce_type(type)
        case type
        when ActiveModel::Type::Value
          type
        else
          Orientdb::ORM::Type.lookup(type)
        end
      end
    end

  end
end
