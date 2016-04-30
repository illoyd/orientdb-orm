module Orientdb
  module ORM
    module Queries

      class Base
        include Orientdb::ORM::Quoting

        def initialize(params = {})
          @params ||= (params || {})
        end

        def self.convert_hash_to_key_value_assignment(hash, glue = ', ')
          hash.map { |k,v| convert_key_value_assignment(k,v) }.join(glue)
        end

        def self.convert_key_value_assignment(k, v)
          "#{ k } = #{ self.quote(v) }"
        end

        def self.convert_hash_to_key_value_assignment_or_inclusion(hash, glue = ', ')
          hash.map { |k,v| convert_key_value_assignment_or_inclusion(k,v) }.join(glue)
        end

        def self.convert_key_value_assignment_or_inclusion(k, v)
          case v
          when Set, Array
            "#{ k } IN #{ self.quote(v) }"
          else
            convert_key_value_assignment(k,v)
          end
        end

        def self.target_rid_for(param)
          if param.respond_to?(:_rid)
            param._rid.to_s
          elsif param.is_a?(Orientdb::ORM::RID)
            param.to_s
          elsif Orientdb::ORM::Queries::Select
            "(#{ param.to_s })"
          else
            param.to_s
          end
        end

        def self.class_for(param, default)
          if param.respond_to?(:_class)
            param._class.to_s
          elsif param.is_a?(Class)
            param.name.demodulize
          else
            param.to_s.presence || default
          end
        end

        protected

        def _execute(sql = nil, conn = nil)
          raise MethodNotImplemented
        end

      end

    end
  end
end