module Orientdb
  module ORM
    class FieldType < HashWithIndifferentAccess

      ##
      # Return a recognised ActiveModel::Type registry name for the given key
      # Not supported:
      #   b (boolean or binary or byte)
      #   m (linkmap)
      def type_for(key)
        case self[key].try(:strip)
        when FloatType
          :float
        when DecimalType
          :decimal
        when ShortType, LongType, DoubleType
          :integer
        when DateType
          :date
        when DateTimeType
          :datetime
        when SetType
          :set
        when LinkType
          :rid
        when LinkSetType
          :linkset
        when LinkListType, LinkBagType
          :linklist
        else
          :value
        end
      end

    end
  end
end