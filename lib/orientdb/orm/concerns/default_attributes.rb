module Orientdb
  module ORM
    module DefaultAttributes
      extend ActiveSupport::Concern

      included do
        
        protected

        def ensure_default_attributes(*params)
          # Merge attributes into object
          self.class.attribute_definitions.values.each do |attr|
            # Configure field type
            self._field_types[attr.name] ||= attr.field_type
            
            # Configure default attribute
            self.attributes[attr.name] ||= attr.default
          end
        end

      end # included

      class_methods do

        def attribute_definitions
          @@attributes       ||= {}
          @@attributes[self] ||= {}
        end
        
        def attribute(name, field_type, options = {})
          attr = AttributeDefinition.new(name, field_type, options)

          # Save attribute for later reference
          attribute_definitions[attr.name] = attr
          
          # Configure validations
          if attr.validates_options.any?
            validates attr.accessor, attr.validates_options
          end
        end
        
      end # class_methods

    end
  end
end