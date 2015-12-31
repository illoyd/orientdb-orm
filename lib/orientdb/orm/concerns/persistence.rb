module Orientdb
  module ORM
    module Persistence
      extend ActiveSupport::Concern

      included do
        
        define_model_callbacks :validation, :save, :create, :update

        def save
          run_callbacks :validation do
            return false unless valid?
          end
          run_callbacks :save do
            create_or_update
          end
        end
        
        def update_attributes(params)
          params.each do |attr, value|
            self[attr] = value
          end
        end
        
        protected
        
        def create_or_update
          persisted? ? update : create
        end
        
      end # included
      
      class_methods do
      end # class_methods

    end
  end
end