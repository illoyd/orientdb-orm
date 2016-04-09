module Orientdb
  module ORM
    module Queries

      class Select < Query
        include HasLimit
        include HasOrder

        def initialize(params = {})
          super
          @params       = self.class.normalize_params(params)
          @projections = @params[:projections]
          @from        = @params[:from]
          @where       = @params[:where]
        end

        def to_query
          sentence = [ 'SELECT', projections_clause, 'FROM', from_clause, where_clause, order_clause, limit_clause.to_s ]
          sentence.flatten.reject(&:blank?).join(' ')
        end

        alias :to_s :to_query

        def projections(params)
          @projections = params
          self
        end

        def from(value)
          @from = value
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

        def projections_clause
          params = case @projections
            when Array
              @projections.join(', ')
            else
              @projections.to_s
            end
          params if params.present?
        end

        def from_clause
          case @from
          when Class
            @from.name.demodulize
          when Orientdb::ORM::RID
            @from.to_s
          else
            if @from.respond_to?(:_rid)
              @from._rid.to_s
            else
              @from.to_s.presence || 'V'
            end
          end
        end

        def where_clause
          params = if @where.is_a?(Hash)
            self.class.convert_hash_to_key_value_assignment(@where, " AND ")
          else
            @where
          end
          "WHERE #{ params }" if params.present?
        end

        protected

        def self.normalize_params(params)
          case params
          when Hash
            params.with_indifferent_access
          when Orientdb::ORM::RID
            { from: params, limit: 1 }
          else
            if params.respond_to?(:_rid)
              { from: params, limit: 1 }
            else
              throw ArgumentError "Unknown params! Given #{ params }. Expected Hash, RID, or Object that responds to _rid."
            end
          end
        end

      end

    end
  end
end