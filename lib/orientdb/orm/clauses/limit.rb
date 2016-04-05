module Orientdb
  module ORM # :nodoc:
    module Clauses

      ##
      # Limit clause support
      class Limit < Orientdb::ORM::Clauses::Base

        def to_s
          "LIMIT #{ self.class.quote(@value) }" if @value.present?
        end

      end # Limit
    end # Clauses
  end # ORM
end # Orientdb
