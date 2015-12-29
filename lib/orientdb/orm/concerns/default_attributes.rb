module Orientdb
  module ORM
    module DefaultAttributes
      extend ActiveSupport::Concern
      
      
      ##
      # TODO: Convert to a struct
      class Attribute
        attr_accessor :name, :field_type, :default, :validates_options
        
        def initialize(name, field_type, default = nil, validates_options = {})
          @name = name
          @field_type = field_type
          @default = default
          @validates_options = validates_options
        end
      end


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
          @@attributes ||= {}
        end
        
        def attribute(name, field_type, default = nil, validates_options = {})
          # Save attribute for later reference
          self.attributes[name] = Attribute.new(name, field_type, default, validates_options)
          
          # Configure validations
          validates name, validates_options
        end
        
      end # class_methods

    end
  end
end