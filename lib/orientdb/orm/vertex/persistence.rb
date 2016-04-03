module Orientdb
  module ORM
    module Vertex
      module Persistence
        extend ActiveSupport::Concern

        included do

          def destroy
            run_callbacks :destroy do
              Orientdb::ORM::Queries::DeleteVertex.new.vertex(self).execute
            end
          end

          protected

          def _create
            run_callbacks :create do
              results = Orientdb::ORM::Queries::CreateVertex.new.vertex(self._class).set(self.serialized_attributes).execute
              assign_attributes(results.first.special_attributes)
              assign_attributes(results.first.attributes)
              changes_applied
              persisted?
            end
          end

          def _update
            run_callbacks :update do
              results = Orientdb::ORM::Queries::UpdateVertex.new.vertex(self).set(self.serialized_attributes).execute
              assign_attributes(results.first.special_attributes)
              assign_attributes(results.first.attributes)
              changes_applied
              persisted?
            end
          end

        end # included

        class_methods do
        end # class_methods

      end
    end
  end
end