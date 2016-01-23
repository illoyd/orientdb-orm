module Orientdb
  module ORM

    ##
    # Type module for type casting and serialising data between ORM objects, the database, and users.
    # This module includes a cache for ActiveModel::Type.lookup, so that we are not spewing dozens
    # of small type casting objects all over the place.
    #
    # Types should still be registered with the main ActiveModel::Type however.
    module Type

      def self.lookup(symbol, *args)
        @@cache ||= HashWithIndifferentAccess.new
        @@cache[symbol] ||= ActiveModel::Type.lookup(symbol, *args)
      end

    end # Type

  end # ORM
end # Orientdb

require 'orientdb/orm/type/rid'
require 'orientdb/orm/type/linklist'
require 'orientdb/orm/type/linkset'
require 'orientdb/orm/type/linkmap'
require 'orientdb/orm/type/field_types'

ActiveModel::Type.register :value,      ActiveModel::Type::Value
ActiveModel::Type.register :link,       Orientdb::ORM::Type::RID
ActiveModel::Type.register :linklist,   Orientdb::ORM::Type::LinkList
ActiveModel::Type.register :linkset,    Orientdb::ORM::Type::LinkSet
ActiveModel::Type.register :linkmap,    Orientdb::ORM::Type::LinkMap
ActiveModel::Type.register :fieldtypes, Orientdb::ORM::Type::FieldTypes
