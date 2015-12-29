module Orientdb
  module ORM
    module VertexPersistence
      extend ActiveSupport::Concern

      included do
        
        def create
          run_callbacks :create do
            results = Orientdb::ORM::Queries::CreateVertex.new.vertex(self._class).set(self.attributes).execute
            update_attributes(results.first.attributes)
            persisted?
          end
        end

        def update
          run_callbacks :update do
            results = Orientdb::ORM::Queries::UpdateVertex.new.vertex(self._rid).set(self.attributes).execute
            results.first['value'] == 1
          end
        end

      end # included
      
      class_methods do
      end # class_methods

    end
  end
end