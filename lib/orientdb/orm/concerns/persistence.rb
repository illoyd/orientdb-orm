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

        def save!
          save || ( raise Orientdb::ORM::ObjectNotSaved.new(nil, self) )
        end

        protected

        def create_or_update
          persisted? ? update : create
        end

      end # included

      class_methods do

        def create(attributes={})
          new(attributes).tap { |object| object.save }
        end

        def create!(attributes={})
          new(attributes).tap { |object| object.save! }
        end

      end # class_methods

    end
  end
end