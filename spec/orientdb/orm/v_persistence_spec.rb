require './spec/spec_helper.rb'

describe Orientdb::ORM::Persistence, :with_database do

  describe ExampleVertex do

    context 'with new document' do
      subject { ExampleVertex.new('name' => 'Test') }

      describe '.save' do

        it 'succeeds' do
          expect{ subject.save }.not_to raise_error
        end

        it 'is persisted' do
          expect{ subject.save }.to change(subject, :persisted?).from(false).to(true)
        end

      end

    end # with new document

    context 'with existing document' do
      subject { ExampleVertex.new('name' => 'Test') }
      before(:each) { subject.save }

      describe '.save' do

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

      end

    end # with existing document

  end

end