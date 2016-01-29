require 'attribute_normalizer'
require 'orientdb/orm/document/schema_aware'
require 'orientdb/orm/document/special_attributes'
require 'orientdb/orm/document/attributes'
require 'orientdb/orm/document/finders'
require 'orientdb/orm/document/persistence'
require 'orientdb/orm/document/attribute_assignment'

module Orientdb
  module ORM

    ##
    # Document module, a baseline mixin for objects to interact with the Orientdb Document system.
    # It is prefereable to use the Vertex or Edge mixins as those provide specific support for each
    # of those types in the Graph database.
    module Document
      extend ActiveSupport::Concern
      extend ActiveModel::Callbacks

      include ActiveModel::Model
      include ActiveModel::AttributeMethods
      include ActiveModel::Dirty

      include Orientdb::ORM::SchemaAware
      include Orientdb::ORM::AttributeAssignment
      include Orientdb::ORM::Attributes
      include Orientdb::ORM::SpecialAttributes
      include Orientdb::ORM::Finders
      include Orientdb::ORM::Persistence

      include AttributeNormalizer

      PROTECTED_KEYS = %w( @rid @class @type @fieldTypes @version )
      EDGE_ATTRIBUTE_REGEX = /^(in|out)_.+$/

      included do
        validates_presence_of :_class

        attribute_method_suffix '?'
        attribute_method_suffix '='

        delegate :to_param, to: :id, allow_nil: true

        def initialize(new_attributes={})
          # Setup basic attributes
          @attributes         = HashWithIndifferentAccess.new
          @special_attributes = HashWithIndifferentAccess.new

          # Install the new field types into the schema
          schema.merge_field_types(new_attributes['@fieldTypes'])

          # Assign all default attributes
          assign_attributes(schema.default_attributes)

          # Allow super to execute
          super

          # Ignore all changes
          changes_applied
        end

        def persisted?
          self.id.try(:persisted?) || false
        end

        def custom_attributes
          attributes.except(*PROTECTED_KEYS)
        end

        def document_attributes
          custom_attributes.reject { |k,_| EDGE_ATTRIBUTE_REGEX.match(k) }
        end

        def edge_attributes
          custom_attributes.select { |k,_| EDGE_ATTRIBUTE_REGEX.match(k) }
        end

      end # included

      class_methods do


      end # class_methods

    end
  end
end