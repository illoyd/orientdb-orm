require "orientdb/orm/version"

require 'active_model'
require 'active_support'
require 'active_support/core_ext'
require 'orientdb4r'
require 'connection_pool'

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
      ( ENV[ ENV['DATABASE_PROVIDER'] || 'DATABASE_URL' ] )
    end

  end
end

require 'uri/orientdb'

require 'orientdb/orm/errors'
require 'orientdb/orm/converters'
require 'orientdb/orm/rid'
require 'orientdb/orm/field_type'
require 'orientdb/orm/concerns/finders'
require 'orientdb/orm/concerns/persistence'
require 'orientdb/orm/document'
require 'orientdb/orm/v'
require 'orientdb/orm/e'
require 'orientdb/orm/client'
