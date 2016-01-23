module Orientdb
  module ORM
    module SpecialAttributes
      extend ActiveSupport::Concern

      included do

        attr_reader :special_attributes

        ##
        # Get this special attribute.
        def special_attribute(name)
          @special_attributes[name]
        end

        ##
        # Model ID for this object.
        def id
          special_attribute('@rid'.freeze)
        end

        ##
        # Legacy support for #_rid; maps to #id.
        alias :_rid :id

        ##
        # Special CLASS attribute from OrientDB
        def _class
          special_attribute('@class'.freeze) || self.class.name.demodulize
        end

        ##
        # Special TYPE attribute from OrientDB
        def _type
          special_attribute('@type'.freeze)
        end

        ##
        # Special FIELDTYPES attribute from OrientDB
        def _field_types
          special_attribute('@fieldTypes'.freeze)
        end

        ##
        # Special VERSION attribute from OrientDB
        def _version
          special_attribute('@version'.freeze)
        end

        private

        def _assign_special_attribute(k, v)
          @special_attributes[k] = _type_cast_value(k, v)
        end

      end # included

      class_methods do

        def special_attribute?(name)
          name.to_s[0] == '@'.freeze
        end

        def select_special_attributes_from_hash(hash)
          hash.select{ |k,_| special_attribute?(k) }
        end

        def reject_special_attributes_from_hash(hash)
          hash.reject{ |k,_| special_attribute?(k) }
        end

      end # class_methods

    end
  end
end