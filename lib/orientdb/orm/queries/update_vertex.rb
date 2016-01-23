module Orientdb
  module ORM
    module Queries

      class UpdateVertex < Base

        def initialize(params = {})
          params       = self.class.normalize_params(params)
          @vertex      = params[:vertex]
          @set         = params[:set]
          @where       = params[:where]
        end

        def execute(conn = nil)
          execute_command_returning_result(to_query)
        end

        def to_query
          sentence = [ 'UPDATE', vertex_clause, set_clause, where_clause ]
          sentence.flatten.reject(&:blank?).join(' ')
        end

        alias :to_s :to_query

        def vertex(value)
          @vertex = value
          self
        end

        def set(options)
          case options
          when Hash
            @set ||= {}
            @set.merge!(options)
          else
            @set = options
          end
          self
        end

        def where(options)
          case options
          when Hash
            @where ||= {}
            @where.merge!(options)
          else
            @where = options
          end
          self
        end

        def vertex_clause
          if @vertex.respond_to?(:_rid)
            @vertex._rid
          elsif @vertex.is_a?(RID)
            @vertex.to_s
          elsif @vertex.is_a?(Class)
            @vertex.name.demodulize
          elsif @vertex.respond_to?(:_class)
            @vertex._class.to_s
          else
            @vertex.to_s.presence || 'V'
          end
        end

        def set_clause
          params = if @set.is_a?(Hash)
            values = @set.except('@rid', '@class', '@version', '@type', '@fieldTypes')
            self.class.convert_hash_to_key_value_assignment(values, ', ')
          else
            @set
          end

          "SET #{ params }" if params.present?
        end

        def where_clause
          params = if @where.is_a?(Hash)
            values = @where.except('@rid', '@class', '@version', '@type', '@fieldTypes')
            self.class.convert_hash_to_key_value_assignment(values, ', ')
          else
            @where
          end

          "WHERE #{ params }" if params.present?
        end

        protected

        def self.normalize_params(params)
          if params.is_a?(Hash)
            params.with_indifferent_access
          elsif params.respond_to?(:attributes)
            {
              vertex: params,
              set:    params.attributes
            }
          else
            throw ArgumentError "Unknown params! Given #{ params }. Expected Hash, or Object that responds to attributes."
          end
        end

      end

    end
  end
end