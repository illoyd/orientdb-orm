require './spec/spec_helper.rb'

describe Orientdb::ORM::FieldType do
  subject do
    Orientdb::ORM::FieldType.new({
      my_short:     Orientdb::ORM::ShortType,
      my_long:      Orientdb::ORM::LongType,
      my_double:    Orientdb::ORM::DoubleType,
      my_float:     Orientdb::ORM::FloatType,
      my_decimal:   Orientdb::ORM::DecimalType,
      my_date:      Orientdb::ORM::DateType,
      my_datetime:  Orientdb::ORM::DateTimeType,
      my_set:       Orientdb::ORM::SetType,
      my_link:      Orientdb::ORM::LinkType,
      my_linkset:   Orientdb::ORM::LinkSetType,
      my_linklist:  Orientdb::ORM::LinkListType,
      my_linkmap:   Orientdb::ORM::LinkMapType,
    })
  end

  describe '#type_for' do
    it 'gets integer for short' do
      expect( subject.type_for(:my_short) ).to eq :integer
    end

    it 'gets integer for long' do
      expect( subject.type_for(:my_long) ).to eq :integer
    end

    it 'gets integer for double' do
      pending 'Orientdb returns double for floats, so assume all doubles are decimals for now.'
      expect( subject.type_for(:my_double) ).to eq :integer
    end

    it 'gets float for float' do
      expect( subject.type_for(:my_float) ).to eq :float
    end

    it 'gets decimal for decimal' do
      expect( subject.type_for(:my_decimal) ).to eq :decimal
    end

    it 'gets date for date' do
      expect( subject.type_for(:my_date) ).to eq :date
    end

    it 'gets date time for date time' do
      expect( subject.type_for(:my_datetime) ).to eq :date_time
    end

    it 'gets set for set' do
      expect( subject.type_for(:my_set) ).to eq :set
    end

    it 'gets link for link' do
      expect( subject.type_for(:my_link) ).to eq :link
    end

    it 'gets link set for link set' do
      expect( subject.type_for(:my_linkset) ).to eq :linkset
    end

    it 'gets link list for link list' do
      expect( subject.type_for(:my_linklist) ).to eq :linklist
    end

    it 'gets link map for link map' do
      expect( subject.type_for(:my_linkmap) ).to eq :linkmap
    end

    it 'otherwise, no coercion' do
      expect( subject.type_for(:bogus) ).to eq :value
    end

    it 'tests all types' do
      expect( subject.values.uniq ).to match_array(Orientdb::ORM::Types)
    end

  end #type_for

  describe 'ActiveModel::Type for all codes' do
    Orientdb::ORM::Types.each do |type|
      it "lookup type for #{ type }" do
        type_symbol = subject.type_for(type)
        expect( Orientdb::ORM::Type.lookup(type_symbol) ).to be_a(ActiveModel::Type::Value)
      end
    end
  end

end
