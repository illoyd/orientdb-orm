module Orientdb
  module ORM
    module Attributes
      extend ActiveSupport::Concern

      included do

        attr_reader :attributes

        ##
        # Return the value
        def attribute(name)
          @attributes[name]
        end

        alias :[] :attribute

        ##
        # Assign the attribute with the given value.
        def attribute=(name, value)
          if _value_changed?(name, @attributes[name], value)
            attribute_will_change!(name)
            @attributes[name] = _type_cast_value(name, value)
          end
        end

        alias :[]= :attribute=

        ##
        # Determines if the attribute is present in the current object.
        def attribute?(attr)
          attribute(attr).present?
        end

        alias :include? :attribute?

        private

        ##
        # Check if value is changing
        def _value_changed?(name, old_value, new_value)
          type = schema.type_for(name)
          cast_value = type.cast(new_value)
          type.changed?(old_value, cast_value, new_value) || type.changed_in_place?(old_value, new_value)
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end