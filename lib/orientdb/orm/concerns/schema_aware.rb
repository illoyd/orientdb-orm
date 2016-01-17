module Orientdb
  module ORM
    module SchemaAware
      extend ActiveSupport::Concern

      included do

        def schema
          @schema ||= self.class.compiled_schema
        end

        private

        ##
        # Type cast the given value by the given attribute name
        def _type_cast_value(name, value)
          schema.type_for(name).cast(value)
        end

        ##
        # Serialize value
        def _serialize_value(name, value)
          schema.type_for(name).serialize(value)
        end

      end # included

      class_methods do

        def schema
          @@schemas       ||= {}
          @@schemas[self] ||= Orientdb::ORM::Schema.new
        end

        def compiled_schema
          ancestors.each_with_object(self.schema) { |klass,s| s.reverse_merge!(@@schemas[klass]) }
        end

      end # class_methods

    end
  end
end