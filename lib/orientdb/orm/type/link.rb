require 'active_model/type'

module Orientdb::ORM
  module Type

    class Link < ActiveModel::Type::Value

      def serialize(value)
        # If this object responds to #id, then reference that instead
        return serialize(value.id) if value.respond_to?(:id)

        # If this object responds to #_rid, then reference that instead
        return serialize(value._rid) if value.respond_to?(:_rid)

        # Otherwise, we'll default to coercing the RID to a string
        value
      end

      private

      def cast_value(value)
        # If value responds to #id, keep the object
        return value if value.respond_to?(:id)

        # If value is a RID, return it
        return value if value.is_a?(Orientdb::ORM::RID)

        # If value matches the regex, return a new RID
        return Orientdb::ORM::RID.new($1.to_i, $2.to_i) if Orientdb::ORM::RID::RID_REGEX.match(value)
      end

    end

  end
end