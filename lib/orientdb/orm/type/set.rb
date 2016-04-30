require 'active_model/type'

module Orientdb::ORM
  module Type

    class Set < Orientdb::ORM::Type::List

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