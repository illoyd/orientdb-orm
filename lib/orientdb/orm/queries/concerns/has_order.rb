module Orientdb
  module ORM
    module Queries

      module HasOrder
        extend ActiveSupport::Concern

        included do

          def order(*value)
            (@params[:order] ||= Clauses::Order.new).append(*value)
            self
          end

          def reorder(*value)
            (@params[:order] ||= Clauses::Order.new).value(*value)
            self
          end

          def order?
            @params[:order].present?
          end

        end #included

        class_methods do
        end #class_methods

      end

    end
  end
end