module Orientdb
  module ORM
    module Finders
      extend ActiveSupport::Concern

      included do
      end
      
      class_methods do
        
        def all
          where
        end
        
        def where(search={})
        
          if search.any?
            where_clause = 'WHERE ' + search.map{ |k,v| "#{ k } = #{ sanitize_parameter(v) }"}.join(" ")
          else
            where_clause = nil
          end

          query = "SELECT FROM #{ self.name.demodulize } #{ where_clause }"
          #results = Giraffe::App.settings.memory.client.query(query)
          results = Orientdb::ORM.with { |client| client.query(query) }
          results.map { |result| new(result) }
          
          rescue Orientdb4r::NotFoundError
            nil
        end
        
        def find_by(search={})
          where(search).first
        end
        
        def find(rid)
          find_by( '@rid' => rid )
        end
        
        alias :find_by_id :find
        alias :find_by_rid :find

      end

    end
  end
end