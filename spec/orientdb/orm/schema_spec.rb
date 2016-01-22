require './spec/spec_helper.rb'

describe Orientdb::ORM::Schema do

  subject do
    described_class.new.tap do |schema|
      schema << Orientdb::ORM::AttributeDefinition.new(:my_string, :string)
      schema << Orientdb::ORM::AttributeDefinition.new(:my_integer, :integer)
      schema << Orientdb::ORM::AttributeDefinition.new(:my_float, :float)
    end
  end

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

end
