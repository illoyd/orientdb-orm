##
# Quoting - shamelessly stolen from ActiveRecord.
module Orientdb
  module ORM # :nodoc:
    module Quoting
      # Quotes the column value to help prevent
      # {SQL injection attacks}[http://en.wikipedia.org/wiki/SQL_injection].
      def quote(value)
        case value
        when String, ActiveSupport::Multibyte::Chars, ActiveModel::Type::Binary::Data
          "'#{quote_string(value.to_s)}'"
        when RID        then value.to_s
        when true       then 'TRUE'
        when false      then 'FALSE'
        when nil        then "NULL"
        # BigDecimals need to be put in a non-normalized form and quoted.
        when BigDecimal then value.to_s('F')
        when Numeric, ActiveSupport::Duration then value.to_s
        when Date, Time then quoted_date(value)
        when Symbol     then "'#{quote_string(value.to_s)}'"
        when Class      then "'#{value}'"
        else raise TypeError, "can't quote #{value.class.name}"
        end
      end

      # Quotes a string, escaping any ' (single quote) and \ (backslash)
      # characters.
      def quote_string(s)
        s.gsub('\\'.freeze, '\&\&'.freeze).gsub("'".freeze, "''".freeze) # ' (for ruby-mode)
      end

      # Quote date/time values for use in SQL input. Includes microseconds
      # if the value is a Time responding to usec.
      def quoted_date(value)
        value.to_time.getutc.to_i.to_s
      end

    end
  end
end