require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkMap < ActiveModel::Type::Value

      def serialize(value)
        rtype = self.class.rid_type
        value.each_with_object({}) { |(k,v),h| h[k] = rtype.serialize(v) }
      end

      private

      def cast_value(value)
        # For every entry, convert to a RID
        rtype = self.class.rid_type
        value.each_with_object({}) { |(k,v),h| h[k] = rtype.cast(v) }
      end

      def self.rid_type
        ActiveModel::Type.lookup(:rid)
      end

    end

  end
end