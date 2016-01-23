require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkList < ActiveModel::Type::Value

      def serialize(value)
        return nil if value.blank?

        rtype = self.class.link_type
        value.map { |v| rtype.serialize(v) }
      end

      private

      def cast_value(value)
        return [] if value.blank?

        # If a string, split by commas
        if value.is_a?(String)
          value = /\A\s*\[?([^\]]+)\]?\s*\Z/.match(value)[1]
          value = value.split(',').map(&:strip)
        end

        # For every entry, convert to a RID
        rtype = self.class.link_type
        value.map { |v| rtype.cast(v) }
      end

      def self.link_type
        ActiveModel::Type.lookup(:link)
      end

    end

  end
end