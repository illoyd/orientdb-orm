require './spec/spec_helper.rb'

describe Orientdb::ORM::Schema do

  subject do
    described_class.new.tap do |schema|
      schema << Orientdb::ORM::AttributeDefinition.new(:my_string, :string)
      schema << Orientdb::ORM::AttributeDefinition.new(:my_integer, :integer)
      schema << Orientdb::ORM::AttributeDefinition.new(:my_float, :float)
      schema << Orientdb::ORM::AttributeDefinition.new(:my_link, :link)
    end
  end

  let(:rid_for_object) { Orientdb::ORM::RID.new(1,2) }
  let(:object_with_id) { Orientdb::ORM::V.new('@rid' => rid_for_object) }

  describe '#serialize' do
    it 'serializes a string' do
      expect( subject.serialize(:my_string, 'hello') ).to eq 'hello'
    end

    it 'serializes an integer' do
      expect( subject.serialize(:my_integer, 5) ).to eq 5
    end

    it 'serializes a float' do
      expect( subject.serialize(:my_float, 1.2) ).to eq 1.2
    end

    it 'serializes an IDable object' do
      expect( subject.serialize(:my_link, object_with_id) ).to eq rid_for_object
    end

    it 'serializes a RID' do
      expect( subject.serialize(:my_link, rid_for_object) ).to eq rid_for_object
    end
  end

  describe '#casts' do
    it 'casts a string' do
      expect( subject.cast(:my_string, 'hello') ).to eq 'hello'
    end

    it 'casts an integer' do
      expect( subject.cast(:my_integer, '5') ).to eq 5
    end

    it 'casts a float' do
      expect( subject.cast(:my_float, '1.2') ).to eq 1.2
    end
  end

  describe '#serialize_attributes' do
    it 'serializes a hash with symbols' do
      input    = { my_integer: '5', my_link: object_with_id }
      expected = { 'my_integer' => 5, 'my_link' => rid_for_object }
      expect( subject.serialize_attributes(input) ).to match(expected)
    end

    it 'serializes a hash with strings' do
      input    = { 'my_integer' => '5', my_link: object_with_id }
      expected = { 'my_integer' => 5, 'my_link' => rid_for_object }
      expect( subject.serialize_attributes(input) ).to match(expected)
    end
  end

end
