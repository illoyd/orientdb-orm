require './spec/spec_helper.rb'

describe Orientdb::ORM::VertexPersistence, :with_database do
  describe ExampleVertex do

    describe '#save' do
        
      context 'with new vertex object' do
        subject { ExampleVertex.new('name' => 'Test') }
        
        it 'is valid before save' do
          expect( subject.valid? ).to be_truthy
        end
  
        it 'succeeds' do
          expect{ subject.save }.not_to raise_error
        end
        
        it 'returns true' do
          expect( subject.save ).to be_truthy
        end
        
        it 'is persisted' do
          expect{ subject.save }.to change(subject, :persisted?).from(false).to(true)
        end

      end # with new document

      context 'with existing document' do
        subject { ExampleVertex.new('name' => 'Test') }
        before(:each) { subject.save }

        it 'succeeds' do
          subject.name = 'Another test'
          expect{ subject.save }.not_to raise_error
        end

        it 'is persisted' do
          subject.name = 'Another test'
          expect{ subject.save }.not_to change(subject, :persisted?).from(true)
        end
        
        it 'changes name value' do
          expect( subject.name ).to eq('Test')
          subject.name = 'Another test'
          subject.save
          expect( subject.name ).to eq('Another test')
        end

      end # with existing document

    end # with existing document
      
  end # ExampleVertex
end # Orientdb::ORM::VertexPersistence
