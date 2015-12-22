require './spec/spec_helper.rb'

describe Orientdb::ORM::FieldType do

  describe '.parse' do

    it 'converts nil to a blank' do
      input    = nil
      expected = Orientdb::ORM::FieldType.default_field_types
      expect( described_class.parse(input).field_types ).to eq(expected)
    end

    it 'converts a simple boolean' do
      input    = 'param=b'
      expected = { 'param' => 'b' }.merge(Orientdb::ORM::FieldType.default_field_types)
      expect( described_class.parse(input).field_types ).to eq(expected)
    end

    it 'converts a date and boolean' do
      input    = 'param1=a,param2=b'
      expected = { 'param1' => 'a', 'param2' => 'b' }.merge(Orientdb::ORM::FieldType.default_field_types)
      expect( described_class.parse(input).field_types ).to eq(expected)
    end

  end

end
