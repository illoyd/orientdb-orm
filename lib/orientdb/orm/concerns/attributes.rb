module Orientdb
  module ORM
    module Attributes
      extend ActiveSupport::Concern

      included do
        
        def update_attributes(params)
          # Merge field types first
          ftypes = params.delete('@field_types')
          _field_types.merge!(ftypes) if ftypes.present?
          
          # Update all other parameters
          params.each do |attr, value|
            self[attr] = value
          end
        end

      end # included
      
      class_methods do
      end # class_methods

    end
  end
end