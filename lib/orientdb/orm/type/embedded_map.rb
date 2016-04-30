require 'active_model/type'

module Orientdb::ORM
  module Type

    class EmbeddedMap < Orientdb::ORM::Type::EmbeddedValue

      def serialize(value)
        value.each_with_object(default) { |(k,v),h| h[k] = embedded_type.serialize(v) }
      end

      def default
        Hash.new
      end

      private

      def cast_value(value)
        # For every entry, convert to a value
        value.each_with_object(default) { |(k,v),h| h[k] = embedded_type.cast(v) }
      end

    end

  end
end