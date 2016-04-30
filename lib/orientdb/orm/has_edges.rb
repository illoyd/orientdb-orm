module Orientdb
  module ORM
    module HasEdges
      extend ActiveSupport::Concern

      InEdgePrefix = 'in_'
      OutEdgePrefix = 'out_'

      included do

        def _edge_name(prefix, edge)
          edge_name = edge.to_s.camelize
          edge_name = prefix + edge_name unless edge_name.start_with?(prefix)
          edge_name
        end

        def _edges(edge_name)
          return [] unless attribute?(edge_name)
          (@edges ||= {})[edge_name] ||= self[edge_name].map { |rid| rid.fetch }
        end

        def _edge_objects(edge_name, method)
          (@edge_objects ||= {})[edge_name] = _edges(edge_name).map { |e| e.send(method).fetch }
        end

        def in_edges(edge)
          _edges(_edge_name(InEdgePrefix, edge))
        end

        def in_objects(edge)
          _edge_objects(_edge_name(InEdgePrefix, edge), :out)
        end

        def out_edges(edge)
          _edges(_edge_name(OutEdgePrefix, edge))
        end

        def out_objects(edge)
          _edge_objects(_edge_name(OutEdgePrefix, edge), :in)
        end

      end

      class_methods do
      end

    end
  end
end