module Orientdb
  module ORM
    module EdgePersistence
      extend ActiveSupport::Concern

      included do
        
        def create
          create_params = createable_attributes.keys.join(', ')
          create_values = createable_attributes.values.map { |v| self.class.sanitize_parameter(v) }.join(', ')
          
          query = "CREATE EDGE #{ _class } FROM #{ self.in._rid.to_s } TO #{ self.out._rid.to_s }"
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
          
          query = "UPDATE EDGE #{ _rid } SET #{ params }"
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