require './spec/spec_helper.rb'

describe Orientdb::ORM::Queries::CreateVertex do

  describe '.new' do
    context 'with full definition' do
      let(:params) {{ vertex: 'ExampleVertex', set: {left: :right} }}
      subject { described_class.new(params) }

      it 'assigns vertex class clause' do
        expect( subject.vertex_clause ).to eq('ExampleVertex')
      end

      it 'assigns set clause' do
        expect( subject.set_clause ).to eq('SET left = "right"')
      end

      it 'assembles SQL' do
        expect( subject.to_s ).to eq('CREATE VERTEX ExampleVertex SET left = "right"')
      end
    end
  end

  describe '#execute', :with_database do
    subject { described_class.new( vertex: 'ExampleVertex', set: {left: 'right'} ) }

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

    it 'assigns multi-line input' do
      value = 'Hello!
      I am a multiline entry.'
      subject.set(multiline: value)
      expect( subject.execute.first.multiline ).to eq(value)
    end

    it 'assigns a string with an escapable character' do
      value = 'Hello! I contain a \'quote\'.'
      subject.set(quoted: value)
      expect( subject.execute.first.quoted ).to eq(value)
    end
  end

end
