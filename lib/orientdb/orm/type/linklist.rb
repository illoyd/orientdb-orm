require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkList < Orientdb::ORM::Type::List

      def initialize
        super(:link)
      end

      def default
        Orientdb::ORM::LinkList.new
      end

      private

      def cast_value(value)
        Orientdb::ORM::LinkList.new(super)
      end

    end

  end
end