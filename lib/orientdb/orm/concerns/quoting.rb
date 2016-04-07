module Orientdb
  module ORM # :nodoc:
    ##
    # Quoting - shamelessly stolen from ActiveRecord.
    module Quoting
      extend ActiveSupport::Concern

      included do
      end #included

      class_methods do

        # Quotes the column value to help prevent
        # {SQL injection attacks}[http://en.wikipedia.org/wiki/SQL_injection].
        def quote(value)
          case value
          when String, ActiveSupport::Multibyte::Chars, ActiveModel::Type::Binary::Data, Class, Symbol
            quote_string(value.to_s)
          when RID               then value.to_s
          when true              then 'TRUE'
          when false             then 'FALSE'
          when nil               then "NULL"
          when BigDecimal, Float then quote_decimal(value)
          when Numeric, ActiveSupport::Duration then value.to_s
          when Date, Time        then quote_date(value)
          when Array, Set        then quote_array(value)
          when Hash              then quote_hash(value)
          when Queries::Base     then quote_query(value)
          else raise TypeError, "can't quote #{value.class.name}"
          end
        end

        protected

        # Quotes a string, escaping any ' (single quote) and \ (backslash)
        # characters.
        def quote_string(value)
          # s.gsub('\\'.freeze, '\&\&'.freeze).gsub("'".freeze, "''".freeze) # ' (for ruby-mode)
          value.to_json
        end

        # Quote date/time values for use in SQL input. Includes microseconds
        # if the value is a Time responding to usec.
        def quote_date(value)
          "DATE('#{ value.strftime('%Y-%m-%d %H:%M:%S') }')"
        end

        def quote_decimal(value)
          "DECIMAL(#{ value.to_s })"
        end

        def quote_hash(value)
          inner = value.map { |k,v| "#{ quote(k) }:#{ quote(v) }" }
          "{#{ inner.join(',') }}"
        end

        def quote_array(value)
          inner = value.map { |v| quote(v) }
          "[#{ inner.join(',') }]"
        end

        def quote_query(value)
          "(#{ value.to_query })"
        end

      end #class_methods

    end
  end
end