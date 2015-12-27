module Orientdb
  module ORM
    module VertexPersistence
      extend ActiveSupport::Concern

      included do
        
        def create
          results = Orientdb::ORM::Queries::CreateVertex.new.vertex(self._class).set(self.attributes).execute
          update_attributes(results.first.attributes)
          true
        end
        
        def update
          params = updateable_attributes.map{ |k,v| "#{ k } = #{ self.class.sanitize_parameter(v) }"}.join(", ")
          
          query = "UPDATE #{ _rid } SET #{ params }"
          #puts "Query: #{ query }"
          
          response = Orientdb::ORM.with { |client| client.command(query) }
          #puts "Update: #{ response }"

          update_attributes(response['result'].first)
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