module Orientdb
  module ORM
    module DefaultAttributes
      extend ActiveSupport::Concern

      included do

        def initialize(*params)
          super
          
          # Merge attributes into object
          self.class.attributes.each do |_,attr|
            # Configure field type
            self._field_types[attr.name] ||= attr.field_type
            
            # Configure default attribute
            self.attributes[attr.name] ||= attr.default
          end
        end

      end # included

      class_methods do

        def attributes
          @@attributes       ||= {}
          @@attributes[self] ||= {}
        end
        
        def attribute(name, field_type, default = nil, validates_options = {})
          attr = Attribute.new(name, field_type, default, validates_options)

          # Save attribute for later reference
          self.attributes[attr.name] = attr
          
          # Configure validations
          if attr.validates_options.any?
            validates attr.name, attr.validates_options
          end
        end
        
      end # class_methods

    end
  end
end