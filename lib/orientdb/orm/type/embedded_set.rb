require 'active_model/type'

module Orientdb::ORM
  module Type

    class EmbeddedSet < Orientdb::ORM::Type::EmbeddedList

      def default
        Set.new
      end

      private

      def cast_value(value)
        Set.new(super)
      end

    end

  end
end