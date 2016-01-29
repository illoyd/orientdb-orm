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
        @normalizers       = _normalizers_or_default options[:normalizes] || options[:normalizers]
      end

      def normalizers
        @cached_normalizers ||= @normalizers.map { |normalizer| normalizer.is_a?(Symbol) ? AttributeNormalizer.configuration.normalizers[normalizer] : normalizer }
      end

      def self.coerce_type(type)
        case type
        when ActiveModel::Type::Value
          type
        else
          Orientdb::ORM::Type.lookup(type)
        end
      end

      private

      def _normalizers_or_default(options = nil)
        if options == :default
          [ :strip, :blank ]
        else
          Array(options)
        end
      end
    end

  end
end
