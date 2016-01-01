require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_group 'ORM',      '/lib/orientdb/orm'
  add_group 'Queries',  '/lib/orientdb/orm/queries'
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
Orientdb4r::logger.level = Logger::FATAL

# Load gem
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'orientdb/orm'

# Require all helpers
Dir.glob('./spec/spec_support/**.rb').each { |file| require file }

# Test for a database path - if not set, fail immediately
raise Orientdb::ORM::InvalidConnectionUrlError, "Missing connection string: Assign DATABASE_URL environment variable. (Given: #{ Orientdb::ORM.connection_url })" unless Orientdb::ORM.connection_url
