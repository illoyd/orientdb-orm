require 'active_model/type'

module Orientdb::ORM
  module Type

    class FieldTypes < ActiveModel::Type::Value

      def serialize(value)
        value.map { |rule| rule.join('=') }.join(',')
      end

      private

      def cast_value(value)
        return value if value.is_a?(Hash)

        types = value.split(',').map { |v| v.split('=') }.to_h
        Orientdb::ORM::FieldType.new(types)
      end

    end

  end
end