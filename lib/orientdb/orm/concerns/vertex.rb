module Orientdb
  module ORM
    module Vertex
      extend ActiveSupport::Concern
      include Orientdb::ORM::Document
      include Orientdb::ORM::VertexPersistence

      included do
      end # included

      class_methods do
      end # class_methods

    end
  end
end