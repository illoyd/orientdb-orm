require 'active_model/type'

module Orientdb::ORM
  module Type

    class LinkMap < Orientdb::ORM::Type::EmbeddedMap

      def initialize
        super(:link)
      end

      def default
        Orientdb::ORM::LinkMap.new
      end

      private

    end

  end
end