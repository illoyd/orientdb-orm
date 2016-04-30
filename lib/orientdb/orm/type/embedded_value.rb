require 'active_model/type'

module Orientdb::ORM
  module Type

    class EmbeddedValue < ActiveModel::Type::Value
      attr_reader :embedded_type

      def initialize(type = nil)
        @embedded_type = case type
          when ActiveModel::Type::Value
            type
          when Symbol, String
            Orientdb::ORM::Type.lookup(type)
          else
            Orientdb::ORM::Type.lookup(:value)
          end
      end

    end

  end
end