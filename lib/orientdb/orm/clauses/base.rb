module Orientdb
  module ORM # :nodoc:
    module Clauses

      ##
      # Base clause support
      class Base
        include Orientdb::ORM::Quoting

        def initialize(value)
          @value = value
        end

        def value(value)
          @value = value
          self
        end

        def to_s
          raise MethodNotImplemented
        end

      end # Limit
    end # Clauses
  end # ORM
end # Orientdb
