require './spec/spec_helper.rb'

describe Orientdb::ORM::Client do

  describe '.new' do

    context 'with defined connection URL' do
      let(:url) { 'orientdb://root:password@localhost' }

      it 'succeeds' do
        expect{ described_class.new(url) }.not_to raise_error
      end

    end

    context 'without a connection URL' do

      it 'succeeds' do
        expect{ described_class.new() }.not_to raise_error
      end

    end

  end

  describe '#connect', :with_database do
    it 'does not share an Orientdb4r::Client' do
      client1 = described_class.new()
      client1.connect
      expect( client1 ).to be_connected

      client2 = described_class.new()
      client2.connect
      expect( client2 ).to be_connected

      expect( client1.client ).not_to eq( client2.client )
    end
  end

end
