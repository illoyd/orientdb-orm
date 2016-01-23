module Orientdb
  module ORM
    module EdgePersistence
      extend ActiveSupport::Concern

      included do

        protected

        def _create
          run_callbacks :create do
            response = Orientdb::ORM::Queries::CreateEdge.new.edge(self._class).from(self.from).to(self.to).set(self.serialized_attributes).execute
            assign_attributes(response.first.special_attributes)
            assign_attributes(response.first.attributes)
          end
        end

        def _update
          run_callbacks :update do
            params = updateable_attributes.map{ |k,v| "#{ k } = #{ self.class.quote(v) }"}.join(", ")

            query = "UPDATE EDGE #{ _rid } SET #{ params }"
            #puts "Query: #{ query }"

            response = Orientdb::ORM.with { |client| client.command(query) }
            #puts "Update: #{ response }"

            assign_attributes(response['result'].first)
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