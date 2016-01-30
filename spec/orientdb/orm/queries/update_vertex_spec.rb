require './spec/spec_helper.rb'

describe Orientdb::ORM::Queries::UpdateVertex do

  describe '.new' do
    context 'with full definition' do
      let(:params) {{ vertex: Orientdb::ORM::RID.new(5,0), set: {left: :right} }}
      subject { described_class.new(params) }

      it 'assigns vertex class clause' do
        expect( subject.vertex_clause ).to eq('#5:0')
      end

      it 'assigns set clause' do
        expect( subject.set_clause ).to eq('SET left = "right"')
      end

      it 'assembles SQL' do
        expect( subject.to_s ).to eq('UPDATE #5:0 SET left = "right" RETURN AFTER')
      end
    end
  end

  describe '#execute', :with_database do
    let(:obj) { ExampleVertex.create! }
    subject   { described_class.new( vertex: obj, set: {left: 'right'} ) }

    it 'returns a result object' do
      expect( subject.execute ).to be_a(Orientdb::ORM::Queries::Result)
    end

    it 'returns a result object with one object' do
      expect( subject.execute.size ).to eq(1)
    end

    it 'returns an ExampleVertex' do
      expect( subject.execute.first ).to be_a(ExampleVertex)
    end

    it 'is persisted' do
      expect( subject.execute.first ).to be_persisted
    end

    it 'assigns #left' do
      expect( subject.execute.first.left ).to eq('right')
    end

  end

end
