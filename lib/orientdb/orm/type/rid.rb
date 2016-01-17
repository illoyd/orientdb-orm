require 'active_model/type'

module Orientdb::ORM
  module Type

    class RID < ActiveModel::Type::Value

      def serialize(value)
        # If this object responds to #id, then reference that instead
        return serialize(value.id) if value.respond_to?(:id)

        # Otherwise, we'll default to coercing the RID to a string
        value.to_s
      end

      private

      def cast_value(value)

        # If value is a RID, return it
        return value if value.is_a?(Orientdb::ORM::RID)

        # If value responds to #id, keep the object
        return value if value.respond_to?(:id)

        # If value matches the regex, return a new RID
        return Orientdb::ORM::RID.new($1.to_i, $2.to_i) if Orientdb::ORM::RID::RID_REGEX.match(value)

      end

    end

  end
end