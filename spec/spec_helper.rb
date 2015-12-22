require 'simplecov'
SimpleCov.start do
#   add_filter '/spec/'
#   add_group 'Models',  '/models/'
#   add_group 'DB',      '/models/db'
#   add_group 'Queries', '/queries'
end

# Include Rspec and related
require 'rspec'
require 'rspec/its'

# Configure RSpec
RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

# Configure OrientDB
require 'orientdb4r'
Orientdb4r::logger.level = 2

# Load gem
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'orientdb/orm'

# Test for a database path - if not set, fail immediately
raise Orientdb::ORM::InvalidConnectionUrlError, "Missing connection string: Assign DATABASE_URL environment variable. (Found: #{ Orientdb::ORM.connection_url })" unless Orientdb::ORM.connection_url


# Establish and drop databases
def create_database_options
  { database: Orientdb::ORM.connection_uri.database, user: Orientdb::ORM.connection_uri.user, password: Orientdb::ORM.connection_uri.password, type: :graph, storage: :memory }
end

def drop_database_options
  { database: Orientdb::ORM.connection_uri.database, user: Orientdb::ORM.connection_uri.user, password: Orientdb::ORM.connection_uri.password }
end

RSpec.shared_context "with database", :with_database => true do
  before(:all) { Orientdb::ORM.with { |conn| conn.client.create_database( create_database_options ) } }
  after(:all)  { Orientdb::ORM.with { |conn| conn.client.delete_database( drop_database_options ) } }
end
