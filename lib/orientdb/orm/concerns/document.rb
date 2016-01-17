module Orientdb
  module ORM
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
      include Orientdb::ORM::DefaultAttributes
      include Orientdb::ORM::Finders
      include Orientdb::ORM::Persistence

      PROTECTED_KEYS = %w( @rid @class @type @fieldTypes @version )
      EDGE_ATTRIBUTE_REGEX = /^(in|out)_.+$/

      included do
        validates_presence_of :_class

        attribute_method_suffix '?'
        attribute_method_suffix '='

        delegate :to_param, to: :id, allow_nil: true

        def initialize(new_attributes={})
          # Setup basic attributes
          @attributes         = {}
          @special_attributes = {}

          # Install the new field types into the schema
          schema.merge_field_types(new_attributes['@fieldTypes'])

          # Merge defaults into the new attribute hash
          new_attributes.reverse_merge!(schema.default_attributes)

          # Allow super to execute now
          super

          # Ignore all changes
          changes_applied
        end

        def persisted?
          self.id.try(:persisted?) || false
        end
#
#
#           attributes ||= {}
#
#           # Initialise the attributes hash using unprotected attributes; this enables magic attributes assignment
#           # @attributes = attributes.except(*PROTECTED_KEYS).with_indifferent_access
#           @attributes = attributes.keys.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) { |k,h| h[k] = nil }
#
#           # Prepare field types; should be called first to enable coercion of all other attributes
#           @attributes['@fieldTypes'] = FieldType.call( attributes['@fieldTypes'] )
#
#           # Assign remaining protected attributes
#           self['@rid']        = attributes['@rid']
#           self['@class']      = attributes['@class'] || self.class.name.demodulize
#           self['@type']       = attributes['@type']
#           self['@version']    = attributes['@version']
#
#           # TODO: Hack to implement default attributes. Can we move?
#           ensure_default_attributes
#
#           # Assign all other attributes
#           super(attributes.except(*PROTECTED_KEYS))
#
#           # Accept all changes
#           changes_applied
#         end

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