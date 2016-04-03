require './spec/spec_helper.rb'

describe Orientdb::ORM::Document, 'finders', :with_database do

  describe ExampleVertex, '.find' do
    let(:obj) { ExampleVertex.create }
    let(:rid) { obj.id }

    it 'finds by string' do
      expect( described_class.find(rid.to_s).id ).to eq(rid)
    end

    it 'finds by RID' do
      expect( described_class.find(rid).id ).to eq(rid)
    end

    it 'finds by object that respodns to ID' do
      expect( described_class.find(obj).id ).to eq(rid)
    end

  end

end