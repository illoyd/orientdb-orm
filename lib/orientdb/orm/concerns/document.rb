module Orientdb
  module ORM
    module Document
      extend ActiveSupport::Concern
      extend ActiveModel::Callbacks

      include ActiveModel::Model
      include ActiveModel::AttributeMethods
      
      include Orientdb::ORM::DefaultAttributes
      include Orientdb::ORM::Finders
      include Orientdb::ORM::Persistence

      included do
        validates_presence_of :_rid, :_class

        attr_reader :attributes

        attribute_method_prefix 'coerce_'
        #attribute_method_prefix ''
        attribute_method_suffix '?'
        attribute_method_suffix '='
        #define_attribute_methods

        PROTECTED_KEYS = %w( @rid @class @type @fieldTypes @version )

        def initialize(attributes={})
          attributes ||= {}

          # Initialise the attributes hash using unprotected attributes; this enables magic attributes assignment
          @attributes = attributes.except(*PROTECTED_KEYS).with_indifferent_access

          # Prepare field types; should be called first to enable coercion of all other attributes
          @attributes['@fieldTypes'] = FieldType.call( attributes['@fieldTypes'] )

          # Assign remaining protected attributes
          self['@rid']        = attributes['@rid']
          self['@class']      = attributes['@class'] || self.class.name.demodulize
          self['@type']       = attributes['@type']
          self['@version']    = attributes['@version']

          # Assign all other attributes
          super(attributes.except(*PROTECTED_KEYS))
        end

        def persisted?
          self._rid.try(:persisted?) || false
        end

        def _rid
          @attributes['@rid']
        end

        def _class
          @attributes['@class'] || self.class.name.demodulize
        end

        def _type
          @attributes['@type']
        end

        def _field_types
          @attributes['@fieldTypes']
        end

        def _version
          @attributes['@version']
        end
        
        def custom_attributes
          @attributes.except(*PROTECTED_KEYS)
        end

        def attribute(attr)
          @attributes[attr]
        end

        alias :[] :attribute

        def attribute=(attr, value)
          @attributes[attr] = coerce_attribute(attr, value)
        end

        alias :[]= :attribute=

        def attribute?(attr)
          @attributes[attr].present?
        end

        alias :include? :attribute?

        def coerce_attribute(attr, value)
          _field_types.coerce(attr, value)
        end
      
      end # included

      class_methods do

        def sanitize_parameter(param)
          case param
          when Numeric
            param
          when Orientdb::ORM::RID
            param.to_s
          when nil
            'NULL'
          else
            "\"#{ param.to_s.gsub('"', '\"') }\""
          end
        end

      end # class_methods

    end
  end
end