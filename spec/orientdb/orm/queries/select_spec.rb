require './spec/spec_helper.rb'

describe Orientdb::ORM::Queries::Select do

  describe '.new' do
    context 'with full definition' do
      let(:params) {{ from: 'Test', projections: [:fieldA, :fieldB], where: {left: :right}, limit: 5, order: :field }}
      subject { described_class.new(params) }

      it 'assigns projections clause' do
        expect( subject.projections_clause ).to eq('fieldA, fieldB')
      end

      it 'assigns from clause' do
        expect( subject.from_clause ).to eq('Test')
      end

      it 'assigns where clause' do
        expect( subject.where_clause ).to eq('WHERE left = "right"')
      end

      it 'assigns limit clause' do
        expect( subject.limit_clause ).to eq('LIMIT 5')
      end

      it 'assembles SQL' do
        expect( subject.to_s ).to eq('SELECT fieldA, fieldB FROM Test WHERE left = "right" LIMIT 5')
      end
    end

    context 'with a RID' do
      let(:params) { Orientdb::ORM::RID.new(1,2) }
      subject { described_class.new(params) }

      it 'does not assign projections clause' do
        expect( subject.projections_clause ).to be_nil
      end

      it 'assigns from clause' do
        expect( subject.from_clause ).to eq(params.to_s)
      end

      it 'does not assign where clause' do
        expect( subject.where_clause ).to be_nil
      end

      it 'assigns limit clause' do
        expect( subject.limit_clause ).to eq('LIMIT 1')
      end

      it 'assembles SQL' do
        expect( subject.to_s ).to eq('SELECT FROM #1:2 LIMIT 1')
      end
    end


    context 'with an object that responds to _rid' do
      let(:params) { ExampleVertex.new('@rid' => '#1:2') }
      subject { described_class.new(params) }

      it 'does not assign projections clause' do
        expect( subject.projections_clause ).to be_nil
      end

      it 'assigns from clause' do
        expect( subject.from_clause ).to eq(params._rid.to_s)
      end

      it 'does not assign where clause' do
        expect( subject.where_clause ).to be_nil
      end

      it 'assigns limit clause' do
        expect( subject.limit_clause ).to eq('LIMIT 1')
      end

      it 'assembles SQL' do
        expect( subject.to_s ).to eq('SELECT FROM #1:2 LIMIT 1')
      end
    end
  end

  describe '#execute', :with_database do
    subject { described_class.new(from: 'ExampleVertex') }
    before(:each) { ExampleVertex.new('hello' => 'world').save }

    it 'returns a result object' do
      expect( subject.execute ).to be_a(Orientdb::ORM::Queries::Result)
    end

    it 'has some items' do
      expect( subject.execute ).not_to be_empty
    end

    it 'produces an ExampleVertex' do
      expect( subject.execute.first ).to be_a(ExampleVertex)
    end
  end

  describe '#where_clause' do

    it 'assigns string clause' do
      expect{ subject.where('test = TRUE') }.to change(subject, :where_clause).from(nil).to('WHERE test = TRUE')
    end

    it 'assigns hash clause' do
      expect{ subject.where({ test: TRUE}) }.to change(subject, :where_clause).from(nil).to('WHERE test = TRUE')
    end

    it 'merges hash clauses' do
      expect{ subject.where({ test: TRUE}) }.to change(subject, :where_clause).from(nil).to('WHERE test = TRUE')
      expect{ subject.where({ test: false}) }.to change(subject, :where_clause).to('WHERE test = FALSE')
      expect{ subject.where({ another: 5}) }.to change(subject, :where_clause).to('WHERE test = FALSE AND another = 5')
    end

  end

end
