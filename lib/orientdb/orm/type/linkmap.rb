require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkMap < ActiveModel::Type::Value

      def serialize(value)
        rtype = self.class.rid_type
        value.each_with_object({}) { |(k,v),h| h[k] = rtype.serialize(v) }
      end

      def default
        Orientdb::ORM::LinkMap.new
      end

      private

      def cast_value(value)
        # For every entry, convert to a RID
        rtype = self.class.rid_type
        value.each_with_object(Orientdb::ORM::LinkMap.new) { |(k,v),h| h[k] = rtype.cast(v) }
      end

      def self.rid_type
        Orientdb::ORM::Type.lookup(:link)
      end

    end

  end
end