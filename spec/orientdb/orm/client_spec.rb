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

end
