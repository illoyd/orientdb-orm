module Orientdb
  module ORM

    class Client
      extend ActiveModel::Callbacks

      attr_reader :connection_uri, :create_database_on_connect

      define_model_callbacks :connect, :disconnect, :query, :command

      before_query :ensure_connected
      before_command :ensure_connected
      before_connect :ensure_database

      def initialize(conn_url = nil, options = {})
        @create_database_on_connect = options[:create_database_on_connect]
        @connection_uri = URI(conn_url || Orientdb::ORM.default_connection_url)
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
          host: @connection_uri.host,
          port: @connection_uri.port,
          ssl:  @connection_uri.ssl?,
          instance: :new
        }
      end

      def connect_options
        {
          database: @connection_uri.database,
          user:     @connection_uri.user,
          password: @connection_uri.password
        }
      end

      def validate_options(options = {})
        options.reverse_merge!(
          create_database_on_connect: false
        )
      end

      def ensure_connected
        connect unless connected?
      end

      def ensure_database
        if create_database_on_connect
          db = Database.new(self)
          db.create unless db.exists?
        end
      end

    end

  end
end