module Orientdb
  module ORM
    module Queries

      class Base
        include Orientdb::ORM::Quoting

        def self.convert_hash_to_key_value_assignment(hash, glue = ', ')
          hash.map { |k,v| "#{ k } = #{ self.quote(v) }" }.join(glue)
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

        def execute_query(sql, conn = nil)
          # If a connection is not given, default to a pool connection.
          return Orientdb::ORM.with { |conn| self.execute_query(sql, conn) } if conn.nil?

          # Compile SQL
          query = self.to_s
          Orientdb::ORM::logger.debug { "#{ self.class.name } SQL: #{ query }" }

          # Execute
          response = conn.query(query)
          Orientdb::ORM::logger.debug { "#{ self.class.name } Response: #{ response }" }

          # Return response
          response

          # Capture record not found errors
          rescue Orientdb4r::NotFoundError
            Result.new([])
        end

        def execute_query_returning_result(sql, conn = nil)
          response = execute_query(to_s)
          # TODO: improve Result object to more intelligently understand the result and apply appropriate conversions
          Result.new( response['result'] ).tap do |results|
            Orientdb::ORM::logger.debug { "#{ self.class.name } Results: #{ results }" }
          end
        end

        def execute_command(sql, conn = nil)
          # If a connection is not given, default to a pool connection.
          return Orientdb::ORM.with { |conn| self.execute_command(sql, conn) } if conn.nil?

          # Compile SQL
          query = self.to_s
          Orientdb::ORM::logger.debug { "#{ self.class.name } SQL: #{ query }" }

          # Execute
          response = conn.command(query)
          Orientdb::ORM::logger.debug { "#{ self.class.name } Response: #{ response }" }

          # Return response
          response

          # Capture record not found errors
          rescue Orientdb4r::NotFoundError
            Result.new([])
        end

        def execute_command_returning_result(sql, conn = nil)
          response = execute_command(to_s)
          # TODO: improve Result object to more intelligently understand the result and apply appropriate conversions
          Result.new( response['result'] ).tap do |results|
            Orientdb::ORM::logger.debug { "#{ self.class.name } Results: #{ results }" }
          end
        end

      end

    end
  end
end