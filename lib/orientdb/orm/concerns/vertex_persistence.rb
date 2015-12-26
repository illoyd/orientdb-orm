module Orientdb
  module ORM
    module VertexPersistence
      extend ActiveSupport::Concern

      included do
        
        def create
          params = createable_attributes.map{ |k,v| "#{ k } = #{ self.class.sanitize_parameter(v) }"}.join(", ")
          
          query = "CREATE VERTEX #{ _class } SET #{ params }"
          #puts "Query: #{ query }"
          
          response = Orientdb::ORM.with { |client| client.command(query) }
          # puts "Create: #{ response }"

          update_attributes(response['result'].first)
        end
        
        def createable_attributes
          attributes.except(*Orientdb::ORM::Document::PROTECTED_KEYS)
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