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

# Common objects
require 'orientdb/orm/rid'

# Type converters
require 'orientdb/orm/type/rid'
require 'orientdb/orm/type/linklist'
require 'orientdb/orm/type/linkset'
require 'orientdb/orm/type/linkmap'
require 'orientdb/orm/type/field_types'

ActiveModel::Type.register :value,      ActiveModel::Type::Value
ActiveModel::Type.register :rid,        Orientdb::ORM::Type::RID
ActiveModel::Type.register :link,       Orientdb::ORM::Type::RID
ActiveModel::Type.register :fieldtypes, Orientdb::ORM::Type::FieldTypes
ActiveModel::Type.register :linklist,   Orientdb::ORM::Type::LinkList
ActiveModel::Type.register :linkset,    Orientdb::ORM::Type::LinkSet
ActiveModel::Type.register :linkmap,    Orientdb::ORM::Type::LinkMap

# Schema
require 'orientdb/orm/schema'

# Object concerns and building blocks
require 'orientdb/orm/concerns/schema_aware'
require 'orientdb/orm/concerns/special_attributes'
require 'orientdb/orm/concerns/attributes'
require 'orientdb/orm/concerns/finders'
require 'orientdb/orm/concerns/persistence'
require 'orientdb/orm/concerns/attribute_assignment'
require 'orientdb/orm/concerns/document'
require 'orientdb/orm/concerns/vertex_persistence'
require 'orientdb/orm/concerns/vertex'
require 'orientdb/orm/concerns/edge_persistence'
require 'orientdb/orm/concerns/edge'

# Public objects
require 'orientdb/orm/v'
require 'orientdb/orm/e'

# Queries
require 'orientdb/orm/queries/quoting'
require 'orientdb/orm/queries/base'
require 'orientdb/orm/queries/result'
require 'orientdb/orm/queries/select'
require 'orientdb/orm/queries/create_vertex'
require 'orientdb/orm/queries/update_vertex'
require 'orientdb/orm/queries/create_edge'

# Client, pool, and database objects
require 'orientdb/orm/client'
require 'orientdb/orm/database'
