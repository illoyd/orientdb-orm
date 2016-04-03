module Orientdb
  module ORM
    module Persistence
      extend ActiveSupport::Concern

      included do

        define_model_callbacks :validation, :save, :create, :update, :destroy

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

        def update(new_attributes)
          assign_attributes(new_attributes)
          save
        end

        def update!(new_attributes)
          assign_attributes(new_attributes)
          save!
        end

        def reload!
          obj = self.class.find(_rid)
          assign_attributes(obj.attributes)
          changes_applied
          self
        end

        protected

        def create_or_update
          persisted? ? _update : _create
        end

        def serialized_attributes
          attributes.each_with_object({}) do |(k,v),h|
            h[k] = _serialize_value(k,v)
          end
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