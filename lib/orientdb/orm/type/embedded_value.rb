require 'active_model/type'

module Orientdb::ORM
  module Type

    class EmbeddedValue < ActiveModel::Type::Value
      attr_reader :embedded_type

      def initialize(type = nil)
        @embedded_type = Orientdb::ORM::Type.lookup(type.presence || :value)
      end

    end

  end
end