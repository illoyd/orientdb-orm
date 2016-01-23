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
          Orientdb::ORM::Queries::Select.new.from(self.name.demodulize).where(search).execute
        end

        def find_by(search={})
          where(search).first
        end

        def find_by!(search={})
          find_by(search) || (raise Orientdb::ORM::ObjectNotFound)
        end

        def find(rid)
          find_by( '@rid' => rid )
        end

        alias :find_by_id :find
        alias :find_by_rid :find

        ##
        # Find or create a new object by the given attributes.
        # Will perform a #find_by and, if not found, create using the given properties.
        def find_or_create_by(attributes)
          find_by(attributes) || create(attributes)
        end

        def find_or_create_by!(attributes)
          find_by(attributes) || create!(attributes)
        end

      end

    end
  end
end