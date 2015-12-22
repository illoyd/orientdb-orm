require './spec/spec_helper.rb'

describe Orientdb::ORM::Persistence, :with_database do
  
  class TestDoc < Orientdb::ORM::V; end
  
  before(:all) { Orientdb::ORM.with { |client| client.command("CREATE CLASS #{ TestDoc.name.demodulize } EXTENDS V") } }
  after(:all)  { Orientdb::ORM.with { |client| client.command("DROP CLASS #{ TestDoc.name.demodulize } UNSAFE") } }
  
  describe TestDoc do

    context 'with new document' do
      subject { TestDoc.new('name' => 'Test') }

      describe '.save' do
        
        it 'succeeds' do
          expect{ subject.save }.not_to raise_error
        end
        
        it 'is persisted' do
          expect{ subject.save }.to change(subject, :persisted?).to(true).from(false)
        end

      end

    end # with new document

    context 'with existing document' do
      subject { TestDoc.new('name' => 'Test') }
      before(:each) { subject.save }

      describe '.save' do
        
        it 'succeeds' do
          expect{ subject.save }.not_to raise_error
        end

        it 'is persisted' do
          expect{ subject.save }.not_to change(subject, :persisted?).from(true)
        end

      end

    end # with new document
      
  end

end