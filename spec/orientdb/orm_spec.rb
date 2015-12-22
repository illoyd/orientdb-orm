require 'spec_helper'

describe Orientdb::ORM do
  it 'has a version number' do
    expect(Orientdb::ORM::VERSION).not_to be nil
  end
  
  describe '.connection_url' do
    let(:url)     { 'orientdb://user:pass@host:2480/database' }
    
    context 'with specified path' do
      before(:each) { Orientdb::ORM.connection_url = nil; ENV['DATABASE_PROVIDER'] = nil; ENV['DATABASE_URL'] = nil }
      
      it 'accepts a new string' do
        expect{ described_class.connection_url = url }.to change(described_class, :connection_url).from(nil).to(url)
      end

    end

    context 'with DATABASE_URL' do
      before(:each) { ENV['DATABASE_PROVIDER'] = nil; ENV['DATABASE_URL'] = url }
      
      it 'reads from DATABASE_URL' do
        expect( described_class.connection_url ).to eq(url)
      end

    end

    context 'with DATABASE_PROVIDER' do
      before(:each) { ENV['DATABASE_PROVIDER'] = 'EXAMPLE_PROVIDER'; ENV['EXAMPLE_PROVIDER'] = url; ENV['DATABASE_URL'] = nil }

      it 'reads from DATABASE_URL' do
        expect( described_class.connection_url ).to eq(url)
      end

    end

  end
end
