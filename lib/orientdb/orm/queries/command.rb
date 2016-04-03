module Orientdb
  module ORM
    module Queries

      class Command < Base

        def execute(sql = nil, conn = nil)
          response = _execute(sql)
          # TODO: improve Result object to more intelligently understand the result and apply appropriate conversions
          Result.new( response['result'] ).tap do |results|
            Orientdb::ORM::logger.debug { "#{ self.class.name } Results: #{ results }" }
          end
        end

        protected

        def _execute(sql = nil, conn = nil)
          # If a connection is not given, default to a pool connection.
          return Orientdb::ORM.with { |conn| self._execute(sql, conn) } if conn.nil?

          # Compile SQL
          sql ||= self.to_s
          Orientdb::ORM::logger.debug { "#{ self.class.name } SQL: #{ sql }" }

          # Execute
          response = conn.command(sql)
          Orientdb::ORM::logger.debug { "#{ self.class.name } Response: #{ response }" }

          # Return response
          response

          # Capture record not found errors
          rescue Orientdb4r::NotFoundError
            Result.new([])
        end

      end

    end
  end
end