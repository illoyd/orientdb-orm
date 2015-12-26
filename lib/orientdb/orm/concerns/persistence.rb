module Orientdb
  module ORM
    module Persistence
      extend ActiveSupport::Concern

      included do
        
        def save
          create_or_update if valid?
        end
        
        def update_attributes(params)
          params.each do |attr, value|
            self[attr] = value
          end
        end
        
        def create_or_update
          persisted? ? update : create
        end
        
      end # included
      
      class_methods do
      end # class_methods

    end
  end
end