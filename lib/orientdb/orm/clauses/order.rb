module Orientdb
  module ORM # :nodoc:
    module Clauses

      ##
      # Limit clause support
      class Order < ArrayBase

        def to_s
          "ORDER #{ @value.join(', ') }" if @value.any?
        end

      end # Limit
    end # Clauses
  end # ORM
end # Orientdb
