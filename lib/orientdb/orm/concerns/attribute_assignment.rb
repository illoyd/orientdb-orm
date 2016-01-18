module Orientdb
  module ORM
    module AttributeAssignment
      extend ActiveSupport::Concern

      included do

        private

        ##
        # Override the 'normal' #_assign_attribute method to redirect special attributes
        # to the special attribute hash, as well dynamically insert the attribute key
        # into the attribute hash to allow implement the rest of the toolkit.
        def _assign_attribute(k, v)
          if self.class.special_attribute?(k)
            _assign_special_attribute(k, v)
          else
            @attributes[k] ||= nil
            super
          end
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end