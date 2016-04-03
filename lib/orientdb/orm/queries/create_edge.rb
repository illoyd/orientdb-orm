module Orientdb
  module ORM
    module Queries

      class CreateEdge < Command

        def initialize(params = {})
          @edge        = params[:edge]
          @from        = params[:from]
          @to          = params[:to]
          @set         = params[:set]
        end

        def to_query
          sentence = [ 'CREATE EDGE', edge_clause, 'FROM', from_clause, 'TO', to_clause, set_clause ]
          sentence.flatten.reject(&:blank?).join(' ')
        end

        alias :to_s :to_query

        def edge(value)
          @edge = value
          self
        end

        def from(value)
          @from = value
          self
        end

        def to(value)
          @to = value
          self
        end

        def set(value)
          case value
          when Hash
            @set ||= {}
            @set.merge!(value)
          else
            @set = value
          end
          self
        end

        def edge_clause
          self.class.class_for(@edge, 'E')
        end

        def from_clause
          self.class.quote Orientdb::ORM::Type.lookup(:link).serialize(@from)
        end

        def to_clause
          self.class.quote Orientdb::ORM::Type.lookup(:link).serialize(@to)
        end

        def set_clause
          params = if @set.is_a?(Hash)
            values = @set.except('@rid', '@class', '@version', '@type', '@fieldTypes', 'in', 'out')
            self.class.convert_hash_to_key_value_assignment(values, ', ')
          else
            @set
          end

          "SET #{ params }" if params.present?
        end

      end

    end
  end
end