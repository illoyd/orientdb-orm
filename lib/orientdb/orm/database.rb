module Orientdb
  module ORM

    class Database
      extend ActiveModel::Callbacks

      attr_reader :client, :options
      delegate :connection_uri, to: :client

      define_model_callbacks :create, :delete, :exists

      def initialize(client_or_conn_url = nil, options = {})
        @client = client_or_conn_url.respond_to?(:client) ? client_or_conn_url : Orientdb::ORM::Client.new(client_or_conn_url)
        @options = options
      end

      def exists?(options = {})
        run_callbacks :exists do
          client.client.database_exists?(exists_options.merge(options))
        end
      end

      def create(options = {})
        run_callbacks :create do
          client.client.create_database(create_options.merge(options))
        end
      end

      def delete(options = {})
        run_callbacks :delete do
          client.client.delete_database(delete_options.merge(options))
        end
      end

      alias :drop :delete
      alias :destroy :delete

      protected

      def exists_options
        {
          database: connection_uri.database,
          user:     connection_uri.user,
          password: connection_uri.password
        }
      end

      def create_options
        {
          database: connection_uri.database,
          user:     connection_uri.user,
          password: connection_uri.password,
          storage:  options[:storage] || :plocal,
          type:     options[:type] || :graph
        }
      end

      def delete_options
        {
          database: connection_uri.database,
          user:     connection_uri.user,
          password: connection_uri.password
        }
      end

    end

  end
end