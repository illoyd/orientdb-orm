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
          serialized_search = compiled_schema.serialize_attributes(search)
          Queries::LazyResult.new(
            Queries::Cached.new(
              Queries::Select.new.from(self.name.demodulize).where(serialized_search)
            )
          )
        end

        def find_by(search={})
          where(search).limit(1).first
        end

        def find_by!(search={})
          find_by(search) || (raise Orientdb::ORM::ObjectNotFound)
        end

        def find(rid)
          find_by( '@rid' => rid )
        end

        alias :find_by_id :find
        alias :find_by_rid :find

        def take(count = nil)
          all.limit(count || 1).last
        end

        def first
          all.order('@rid ASC').limit(1).first
        end

        def last
          all.order('@rid DESC').limit(1).first
        end

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