module Orientdb
  module ORM
    module Queries

      module HasLimit
        extend ActiveSupport::Concern

        included do

          def limit(value)
            @params[:limit] = value
            self
          end

          def limit_clause
            Orientdb::ORM::Clauses::Limit.new(@params[:limit])
          end

        end #included

        class_methods do
        end #class_methods

      end

    end
  end
end