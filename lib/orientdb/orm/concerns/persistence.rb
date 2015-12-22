module Orientdb
  module ORM
    module Persistence
      extend ActiveSupport::Concern

      included do
        
        def save
          create_or_update if valid?
        end
        
        def update_attributes(params)
          params.each do |attr, value|
#               self.public_send("#{attr}=", value)
            self[attr] = value
          end
        end
        
        def create_or_update
          persisted? ? update : create
        end
        
        def create
          create_class  = _class.presence || self.class.name.demodulize
          create_params = createable_attributes.keys.join(', ')
          create_values = createable_attributes.values.map { |v| self.class.sanitize_parameter(v) }.join(', ')
          
          query = "INSERT INTO #{ create_class } ( #{ create_params } ) VALUES ( #{ create_values } )"
          #puts "Query: #{ query }"
          
          response = Orientdb::ORM.with { |client| client.command(query) }
          # response = Giraffe::App.settings.memory.client.command(query)
          # puts "Create: #{ response }"

          update_attributes(response['result'].first)
        end
        
        def createable_attributes
          attributes.except(*Orientdb::ORM::Document::PROTECTED_KEYS)
        end
        
        def update
          update_class  = _class.presence || self.class.name.demodulize
          update_params = updateable_attributes.map{ |k,v| "#{ k } = #{ self.class.sanitize_parameter(v) }"}.join(", ")
          
          #query = "UPDATE #{ update_class } SET ( #{ update_params } ) WHERE ( '@rid' = #{ _rid } )"
          query = "UPDATE #{ _rid } SET #{ update_params }"
          #puts "Query: #{ query }"
          
          # response = Giraffe::App.settings.memory.client.command(query)
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