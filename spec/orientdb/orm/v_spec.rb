require './spec/spec_helper.rb'

describe Orientdb::ORM::V do

  describe '#new' do

    context 'without attributes' do

      it 'succeeds' do
        expect{ subject }.not_to raise_error
      end

      it 'has default attributes' do
        # expect( subject.attributes.keys ).to match_array %w( @rid @class @type @fieldTypes @version )
        expect( subject.attributes.keys ).to be_empty
      end

      its('_rid')         { should be_nil }
      its('_class')       { should eq('V') }
      its('_type')        { should be_nil }
      its('_version')     { should be_nil }
      its('_field_types') { should be_nil }

      describe 'persisted attributes' do
        its('persisted?') { should be false }
      end

    end

    context 'with persisted OUser document' do
      let(:attributes) { {"@type"=>"d", "@rid"=>"#5:0", "@version"=>1, "@class"=>"OUser", "name"=>"admin", "password"=>"{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918", "status"=>"ACTIVE", "roles"=>["#4:0"], "@fieldTypes"=>"roles=n"} }
      subject { described_class.new(attributes) }

      it 'succeeds' do
        expect{ subject }.not_to raise_error
      end

      describe 'special attributes' do
        its('_rid')              { should be_a(Orientdb::ORM::RID) }
        its('_rid')              { should eq('#5:0') }
        its('_rid.collection')   { should eq(5) }
        its('_rid.position')     { should eq(0) }

        its('_type')             { should eq('d') }

        its('_class')            { should eq('OUser') }

        its('_version')          { should eq(1) }

        its('_field_types')      { should be_a(Orientdb::ORM::FieldType) }
        its('_field_types')      { should eq('roles'=>'n') }
      end

      describe 'persisted attributes' do
        its('persisted?') { should be true }
      end

      describe 'document attributes' do
        its('name?')     { should be true }
        its('name')      { should eq('admin') }

        its('password?') { should be true }
        its('password')  { should eq('{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918') }

        its('status?')   { should be true }
        its('status')    { should eq('ACTIVE') }
      end

      describe 'document links' do
        its('roles?')      { should be true }
        its('roles')       { should be_a(Set) }
        its('roles')       { should match_array([ Orientdb::ORM::RID.new(4,0) ]) }
        its('roles.first') { should be_a(Orientdb::ORM::RID) }
      end

    end

  end

end