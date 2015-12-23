require 'spec_helper'

# Create the test database
def create_database
  options = { database: Orientdb::ORM.connection_uri.database, user: Orientdb::ORM.connection_uri.user, password: Orientdb::ORM.connection_uri.password, type: :graph, storage: :memory }
  Orientdb::ORM.with { |conn| conn.client.create_database( options ) }
end

# Drop the test database
def drop_database
  options = { database: Orientdb::ORM.connection_uri.database, user: Orientdb::ORM.connection_uri.user, password: Orientdb::ORM.connection_uri.password }
  Orientdb::ORM.with { |conn| conn.client.delete_database( options ) }
end

# Create database classes
def create_database_classes
  Orientdb::ORM.with do |conn|
    conn.command( "CREATE CLASS #{ ExampleVertex.name.demodulize } EXTENDS V" )
    conn.command( "CREATE CLASS #{ ExampleEdge.name.demodulize } EXTENDS E" )
  end
end  

# Drop database classes
def drop_database_classes
  Orientdb::ORM.with do |conn|
    conn.command( "DROP CLASS #{ ExampleVertex.name.demodulize } UNSAFE" )
    conn.command( "DROP CLASS #{ ExampleEdge.name.demodulize } UNSAFE" )
  end
end  

RSpec.shared_context "with database", :with_database => true do
  before(:all)  { create_database }
  before(:all)  { create_database_classes }
  after(:all)   { drop_database }
  # after(:each)  { drop_database_classes }
end
