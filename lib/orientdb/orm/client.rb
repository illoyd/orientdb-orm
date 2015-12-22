module Orientdb
  module ORM

    class Client

      attr_reader :connection_url

      def initialize(conn_url = nil)
        @connection_url = URI(conn_url || Orientdb::ORM.default_connection_url)
      end
      
      def client
        @client ||= Orientdb4r.client(client_options)
      end
      
      def connect
        client.connect(connect_options)
      end
      
      def disconnect
        @client.disconnect if connected?
        @client = nil
      end
      
      def connected?
        @client.try(:connected?) || false
      end
      
      def query(*params)
        connect unless connected?
        client.query(*params)
      end
      
      def command(*params)
        connect unless connected?
        client.command(*params)
      end
      
      protected

      def client_options
        {
          host: @connection_url.host,
          port: @connection_url.port,
          ssl:  @connection_url.ssl?
        }
      end

      def connect_options
        {
          database: @connection_url.database,
          user:     @connection_url.user,
          password: @connection_url.password
        }
      end

    end

  end
end