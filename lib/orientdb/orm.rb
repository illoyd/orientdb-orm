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
      @@logger ||= Orientdb4r::logger
    end

    def self.logger=(value)
      @@logger = Orientdb4r::logger = value
    end

  end
end

# Configuration of logging.
Orientdb::ORM::logger.level = Logger::WARN

require 'uri/orientdb'

require 'orientdb/orm/constants'
require 'orientdb/orm/errors'
require 'orientdb/orm/field_type'
require 'orientdb/orm/attribute_definition'
require 'orientdb/orm/identity_delegator'

# Common objects
require 'orientdb/orm/rid'

# Type converters
require 'orientdb/orm/type'

# Schema
require 'orientdb/orm/schema'

# Object concerns and building blocks
require 'orientdb/orm/document'
require 'orientdb/orm/vertex'
require 'orientdb/orm/edge'

# Public objects
require 'orientdb/orm/v'
require 'orientdb/orm/e'

# Quoting
require 'orientdb/orm/concerns/quoting'

# Clauses
require 'orientdb/orm/clauses/base'
require 'orientdb/orm/clauses/limit'

# Mixins for queries
require 'orientdb/orm/queries/concerns/has_limit'

# Queries
require 'orientdb/orm/queries/base'
require 'orientdb/orm/queries/query'
require 'orientdb/orm/queries/command'
require 'orientdb/orm/queries/cached'
require 'orientdb/orm/queries/result'
require 'orientdb/orm/queries/lazy_result'
require 'orientdb/orm/queries/select'
require 'orientdb/orm/queries/create_vertex'
require 'orientdb/orm/queries/update_vertex'
require 'orientdb/orm/queries/delete_vertex'
require 'orientdb/orm/queries/create_edge'

# Client, pool, and database objects
require 'orientdb/orm/client'
require 'orientdb/orm/database'
