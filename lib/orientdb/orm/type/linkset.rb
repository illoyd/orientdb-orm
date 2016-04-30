require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkSet < Orientdb::ORM::Type::LinkList

      def default
        Orientdb::ORM::LinkSet.new
      end

      private

      def cast_value(value)
        Orientdb::ORM::LinkSet.new(super)
      end

    end

  end
end