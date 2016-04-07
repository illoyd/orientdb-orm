module Orientdb
  module ORM # :nodoc:
    module Clauses

      ##
      # Base clause support
      class ArrayBase
        include Orientdb::ORM::Quoting

        def initialize(*value)
          value(*value)
        end

        def value(*value)
          @value = Array(value).flatten.reject(&:blank?)
          self
        end

        def append(value)
          @value << value if value.present?
        end

        def prepend(value)
          @value.unshift(value) if value.present?
        end

        def to_s
          raise MethodNotImplemented
        end

      end # Limit
    end # Clauses
  end # ORM
end # Orientdb
