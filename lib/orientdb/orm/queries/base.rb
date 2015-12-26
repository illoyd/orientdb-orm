module Orientdb
  module ORM
    module Queries

      class Base
        
        def self.sanitize_parameter(param)
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
          
          # Otherwise, escape!
          else
            "\"#{ param.to_s.gsub('"', '\"') }\""
          end
        end
        
        def self.convert_hash_to_key_value_assignment(hash, glue = ', ')
          hash.map { |k,v| "#{ k } = #{ sanitize_parameter(v) }" }.join(glue)
        end
        
      end
  
    end
  end
end