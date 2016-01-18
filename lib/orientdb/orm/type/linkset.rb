require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkSet < Orientdb::ORM::Type::LinkList

      private

      def cast_value(value)
        Set.new(super)
      end

    end

  end
end