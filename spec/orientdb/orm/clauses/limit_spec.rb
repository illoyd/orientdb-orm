require './spec/spec_helper.rb'

describe Orientdb::ORM::Clauses::Limit do

  describe '#to_s' do

    it 'ignores nil' do
      expect( described_class.new(nil).to_s ).to be_nil
    end

    it 'uses 1' do
      expect( described_class.new(1).to_s ).to eq('LIMIT 1')
    end

    it 'uses 5' do
      expect( described_class.new(5).to_s ).to eq('LIMIT 5')
    end

    it 'uses :symbol' do
      pending 'Explore how to use symbol interpolation for LIMIT clause'
      expect( described_class.new(:symbol).to_s ).to eq('LIMIT :symbol')
    end

    it 'uses string' do
      expect( described_class.new('string').to_s ).to eq('LIMIT "string"')
    end

    it 'uses a subquery' do
      subquery = Orientdb::ORM::Queries::Select.new.projections('count').from('objects')
      expect( described_class.new(subquery).to_s ).to eq('LIMIT (SELECT count FROM objects)')
    end

    it 'uses -2' do
      expect( described_class.new(-2).to_s ).to eq('LIMIT -2')
    end

    it 'uses 0' do
      expect( described_class.new(0).to_s ).to eq('LIMIT 0')
    end

    it 'uses 1.5' do
      expect( described_class.new(1.5).to_s ).to eq('LIMIT DECIMAL(1.5)')
    end

  end

end
