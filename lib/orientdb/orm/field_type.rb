module Orientdb
  module ORM
    class FieldType < HashWithIndifferentAccess

      ##
      # Return a recognised ActiveModel::Type registry name for the given key
      # Not supported:
      #   b (boolean or binary or byte)
      # Doubles are processed as Decimals due to the way the database incorrectly reports floats as doubles.
      def type_for(key)
        case self[key].try(:strip)
        when FloatType
          :float
        when DecimalType, DoubleType
          :decimal
        when ShortType, LongType
          :integer
        when DateType
          :date
        when DateTimeType
          :datetime
        when SetType
          :set
        when LinkType
          :link
        when LinkSetType
          :linkset
        when LinkListType, LinkBagType
          :linklist
        when LinkMapType
          :linkmap
        else
          :value
        end
      end

    end
  end
end