require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkList < ActiveModel::Type::Value

      def serialize(value)
        rtype = self.class.rid_type
        value.map { |v| rtype.serialize(v) }
      end

      private

      def cast_value(value)
        # If a string, split by commas
        value = value.split(',').map(&:strip) if value.is_a?(String)

        # For every entry, convert to a RID
        rtype = self.class.rid_type
        value.map { |v| rtype.cast(v) }
      end

      def self.rid_type
        ActiveModel::Type.lookup(:rid)
      end

    end

  end
end