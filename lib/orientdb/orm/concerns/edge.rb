module Orientdb
  module ORM
    module Edge
      extend ActiveSupport::Concern
      include Orientdb::ORM::Document
      include Orientdb::ORM::EdgePersistence

      included do
        attribute :in,  Orientdb::ORM::LinkType, validations: { presence: true }
        attribute :out, Orientdb::ORM::LinkType, validations: { presence: true }
      end # included

      class_methods do
      end # class_methods

    end
  end
end