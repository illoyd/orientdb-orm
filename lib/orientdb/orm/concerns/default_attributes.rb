module Orientdb
  module ORM
    module DefaultAttributes
      extend ActiveSupport::Concern

      included do
      end # included

      class_methods do

        def attribute(name, type, options = {})
          attr = AttributeDefinition.new(name, type, options)

          # Save attribute into schema
          self.schema << attr

          # Configure validations
          if attr.validates_options.try(:any?)
            validates(attr.accessor, attr.validates_options)
          end
        end

      end # class_methods

    end
  end
end