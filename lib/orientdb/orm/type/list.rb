require 'active_model/type'

module Orientdb::ORM
  module Type

    class List < Orientdb::ORM::Type::EmbeddedValue

      def serialize(value)
        return nil if value.blank?
        value.map { |v| embedded_type.serialize(v) }
      end

      def default
        Array.new
      end

      private

      def cast_value(value)
        return [] if value.blank?

        # If a string, split by commas
        if value.is_a?(String)
          value = /\A\s*\[?([^\]]+)\]?\s*\Z/.match(value)[1]
          value = value.split(',').map(&:strip)
        end

        # For every entry, type cast it
        value.map { |v| embedded_type.cast(v) }
      end

    end

  end
end