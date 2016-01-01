module Orientdb
  module ORM
    module Queries

      class CreateEdge < Base
        
        def initialize(params = {})
          params       = self.class.normalize_params(params)
          @edge        = params[:edge]
          @from        = params[:from]
          @to          = params[:to]
          @set         = params[:set]
        end
        
        def execute(conn = nil)
          return Orientdb::ORM.with { |client| self.execute(client) } if conn.nil?
          puts self.to_s
          Result.new( conn.command(self.to_s)['result'] )

          rescue Orientdb4r::NotFoundError
            Result.new([])
        end
        
        def to_s
          sentence = [ 'CREATE EDGE', edge_clause, 'FROM', from_clause, 'TO', to_clause, set_clause ]
          sentence.reject(&:blank?).join(' ')
        end
        
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
        
        def edge_clause
          self.class.class_for(@edge, 'E')
        end
        
        def from_clause
          self.class.target_rid_for(@from)
        end
        
        def to_clause
          self.class.target_rid_for(@to)
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
        
        protected
        
        def self.normalize_params(params)
          if params.is_a?(Hash)
            params.with_indifferent_access
          elsif params.respond_to?(:attributes)
            {
              edge:   params,
              to:     params.in,
              from:   params.out,
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