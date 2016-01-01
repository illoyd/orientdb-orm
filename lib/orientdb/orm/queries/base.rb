module Orientdb
  module ORM
    module Queries

      class Base
        
        def self.sanitize_parameter(param)
          # Short-circuit if object can convert self to a parameter entry
          # return param.to_param if param.respond_to?(:to_param)
          
          # Short-circuit with _rid check
          return param._rid.to_s if param.respond_to?(:_rid)

          # Otherwise, perform conversion internally
          case param
            
          # Do not escape certain key value types
          when Numeric, true, false
            param
          
          # Convert NIL to NULL
          when nil
            'NULL'

          # Convert certain values into strings but do not escape
          when Orientdb::ORM::RID
            param.to_s
          
          # Sanitize hashes
          when Hash
            param.each_with_object({}) { |(k,v),h| h[k] = sanitize_parameter(v) }
          
          # Sanitize arrays and sets
          when Array, Set
            param.map { |v| sanitize_parameter(v) }
          
          # Otherwise, escape!
          else
            "\"#{ param.to_s.gsub('"', '\"') }\""
          end
        end
        
        def self.convert_hash_to_key_value_assignment(hash, glue = ', ')
          hash.map { |k,v| "#{ k } = #{ sanitize_parameter(v) }" }.join(glue)
        end
        
        def self.target_rid_for(param)
          if param.respond_to?(:_rid)
            param._rid.to_s
          elsif param.is_a?(Orientdb::ORM::RID)
            param.to_s
          elsif Orientdb::ORM::Queries::Select
            "(#{ param.to_s })"
          else
            param.to_s
          end
        end
        
        def self.class_for(param, default)
          if param.respond_to?(:_class)
            param._class.to_s
          elsif param.is_a?(Class)
            param.name.demodulize
          else
            param.to_s.presence || default
          end
        end
        
      end
  
    end
  end
end