module Orientdb
  module ORM
    module Edge
      extend ActiveSupport::Concern
      include Orientdb::ORM::Document
      include Orientdb::ORM::EdgePersistence

      included do
        attribute :in,  :link, validations: { presence: true }
        #attribute :out, :link, validations: { presence: true }

        def from
          attribute('out'.freeze)
        end

        def to
          attribute('in'.freeze)
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end