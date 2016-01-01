module Orientdb
  module ORM

    class Client
      extend ActiveModel::Callbacks

      attr_reader :connection_url
      
      define_model_callbacks :connect, :disconnect, :query, :command
      
      before_query :ensure_connected
      before_command :ensure_connected

      def initialize(conn_url = nil)
        @connection_url = URI(conn_url || Orientdb::ORM.default_connection_url)
      end
      
      def client
        @client ||= Orientdb4r.client(client_options)
      end
      
      def connect
        run_callbacks :connect do
          client.connect(connect_options) unless connected?
          client
        end
      end
      
      def disconnect
        run_callbacks :disconnect do
          @client.disconnect if connected?
          @client = nil
        end
      end
      
      def connected?
        @client.try(:connected?) || false
      end
      
      def query(*params)
        run_callbacks :query do
          client.query(*params)
        end
      end
      
      def command(*params)
        run_callbacks :command do
          client.command(*params)
        end
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
      
      def ensure_connected
        connect unless connected?
      end

    end

  end
end