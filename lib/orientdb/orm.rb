require "orientdb/orm/version"

require 'active_model'
require 'active_support'
require 'active_support/core_ext'
require 'orientdb4r'
require 'connection_pool'
require 'logger'

module Orientdb
  module ORM

    def self.pool
      @@pool ||= ConnectionPool.new { Client.new(connection_url) }
    end

    def self.shutdown
      @@pool.shutdown { |conn| conn.disconnect } if pool?
    end

    def self.pool?
      !@@pool.nil?
    end

    def self.with(options = {}, &block)
      pool.with(options, &block)
    end

    def self.connection_url
      @@connection_url ||= default_connection_url
    end

    def self.connection_url=(url)
      @@connection_url = url
    end

    def self.connection_uri
      URI(connection_url)
    end

    def self.default_connection_url
      ENV[ ENV['DATABASE_PROVIDER'] || 'DATABASE_URL' ]
    end

    def self.object_namespace
      @@namespace ||= nil
    end

    def self.object_namespace=(value)
      @@namespace = value
    end

    def self.logger
      @@logger ||= Logger.new(STDOUT)
    end

    def self.logger=(value)
      @@logger = value
    end

  end
end

# Configuration of logging.
Orientdb::ORM::logger.level = Logger::INFO

require 'uri/orientdb'

require 'orientdb/orm/constants'
require 'orientdb/orm/errors'
require 'orientdb/orm/converters'
require 'orientdb/orm/rid'
require 'orientdb/orm/field_type'
require 'orientdb/orm/attribute_definition'
require 'orientdb/orm/concerns/finders'
require 'orientdb/orm/concerns/persistence'
require 'orientdb/orm/concerns/default_attributes'
require 'orientdb/orm/concerns/attributes'
require 'orientdb/orm/concerns/document'
require 'orientdb/orm/concerns/vertex_persistence'
require 'orientdb/orm/concerns/vertex'
require 'orientdb/orm/concerns/edge_persistence'
require 'orientdb/orm/concerns/edge'
require 'orientdb/orm/v'
require 'orientdb/orm/e'
require 'orientdb/orm/client'
require 'orientdb/orm/database'

require 'orientdb/orm/queries/base'
require 'orientdb/orm/queries/result'
require 'orientdb/orm/queries/select'
require 'orientdb/orm/queries/create_vertex'
require 'orientdb/orm/queries/update_vertex'
require 'orientdb/orm/queries/create_edge'
