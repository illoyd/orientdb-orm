module Orientdb
  module ORM
    module Queries

      class CreateVertex < Base

        def initialize(params = {})
          params       = self.class.normalize_params(params)
          @vertex      = params[:vertex]
          @set         = params[:set]
        end

        def execute(conn = nil)
          return Orientdb::ORM.with { |client| self.execute(client) } if conn.nil?
          Result.new( conn.command(self.to_s)['result'] )

          rescue Orientdb4r::NotFoundError
            Result.new([])
        end

        def to_s
          sentence = [ 'CREATE VERTEX', vertex_clause, set_clause ]
          sentence.flatten.reject(&:blank?).join(' ')
        end

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

        def vertex_clause
          if @vertex.is_a?(Class)
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