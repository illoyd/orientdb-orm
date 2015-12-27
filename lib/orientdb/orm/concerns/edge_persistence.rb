module Orientdb
  module ORM
    module EdgePersistence
      extend ActiveSupport::Concern

      included do
        
        def create
          run_callbacks :create do
            response = Orientdb::ORM::Queries::CreateEdge.new(self).execute
            update_attributes(response.first.attributes)
          end
        end

        def update
          run_callbacks :update do
            params = updateable_attributes.map{ |k,v| "#{ k } = #{ self.class.sanitize_parameter(v) }"}.join(", ")
            
            query = "UPDATE EDGE #{ _rid } SET #{ params }"
            #puts "Query: #{ query }"
            
            response = Orientdb::ORM.with { |client| client.command(query) }
            #puts "Update: #{ response }"
  
            update_attributes(response['result'].first)
          end
        end
        
        def updateable_attributes
          attributes.except('@class', '@rid', '@type', '@fieldTypes', '@version')
        end

      end # included
      
      class_methods do
      end # class_methods

    end
  end
end