require './spec/spec_helper.rb'

def new_connection_url
  Orientdb::ORM.connection_uri.tap { |uri| uri.database = 'brand_spanking_new' }.to_s
end

def existing_connection_url
  Orientdb::ORM.connection_uri.to_s
end

describe Orientdb::ORM::Database do

  describe '.exists?', :with_database do

    it "does not find the new #{ URI(new_connection_url).database } database" do
      expect( described_class.new(new_connection_url) ).not_to exist
    end

    it "finds the existing #{ URI(existing_connection_url).database } database" do
      expect( described_class.new(existing_connection_url) ).to exist
    end

  end

  describe '.create' do
    subject { described_class.new(Orientdb::ORM.connection_url, storage: :memory) }
    after   { described_class.new(Orientdb::ORM.connection_url).delete }

    it "creates the #{ URI(Orientdb::ORM.connection_url).database } database" do
      expect{ subject.create }.to change{ subject.exists? }.from(false).to(true)
    end

  end

  describe '.delete' do
    subject { described_class.new(Orientdb::ORM.connection_url, storage: :memory) }
    before  { subject.create }

    it "deletes the #{ URI(Orientdb::ORM.connection_url).database } database" do
      expect{ subject.delete }.to change{ subject.exists? }.from(true).to(false)
    end

  end

end
