module Orientdb
  module ORM
    class Schema

      attr_reader :attributes

      delegate :keys, to: :attributes

      def initialize()
        @attributes = {}

        self << AttributeDefinition.new('@rid', :rid)
        self << AttributeDefinition.new('@fieldTypes', :fieldtypes)

        # Set a default attribute definition if one is not already set
        if @attributes.default.nil?
          @attributes.default = AttributeDefinition.new(nil, :string)
        end
      end

      def <<(attr)
        @attributes[attr.name] = attr
      end

      def [](name)
        @attributes[name.to_s]
      end

      def type_for(name)
        self[name].type
      end

      def default_for(name)
        self[name].default
      end

      def default_attributes
        @attributes.values.each_with_object({}) do |v,h|
          h[v.name] = v.default
        end
      end

      def merge!(other)
        @attributes.merge!(other.attributes)
      end

      def reverse_merge!(other)
        @attributes.reverse_merge!(other.attributes)
      end

      def merge_field_types(field_types = {})
        return if field_types.nil?

        field_types = ActiveModel::Type.lookup(:fieldtypes).cast(field_types)

        field_types.each do |k,_|
          code = field_types.type_for(k)
          type = ActiveModel::Type.lookup(code)
          @attributes[k] = AttributeDefinition.new(k, type)
        end
      end

    end
  end
end