require 'orientdb/orm/edge/persistence'

module Orientdb
  module ORM
    module Edge
      extend ActiveSupport::Concern
      include Orientdb::ORM::Document
      include Orientdb::ORM::Edge::Persistence

      included do
        attribute :in,  :link, validations: { presence: true }
        attribute :out, :link, validations: { presence: true }

        def from
          attribute('out'.freeze)
        end

        def from_object
          @from_object ||= from.fetch
        end

        def to
          attribute('in'.freeze)
        end

        def to_object
          @to_object ||= to.fetch
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end