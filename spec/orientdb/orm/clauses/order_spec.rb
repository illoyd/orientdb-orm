require './spec/spec_helper.rb'

describe Orientdb::ORM::Clauses::Order do

  describe '#to_s' do

    context 'by prepending' do
      subject { described_class.new('field1') }

      it 'ignores nil' do
        expect{ subject.prepend(nil) }.not_to change(subject, :to_s)
      end

      it 'uses field2' do
        expect{ subject.prepend('field2') }.to change(subject, :to_s).to('ORDER field2, field1')
      end
    end

    context 'by appending' do
      subject { described_class.new('field1') }

      it 'ignores nil' do
        expect{ subject.append(nil) }.not_to change(subject, :to_s)
      end

      it 'uses field2' do
        expect{ subject.append('field2') }.to change(subject, :to_s).to('ORDER field1, field2')
      end
    end

    context 'with single value' do

      it 'ignores nil' do
        expect( described_class.new(nil).to_s ).to be_nil
      end

      it 'uses field_name' do
        expect( described_class.new('field_name').to_s ).to eq('ORDER field_name')
      end

      it 'uses field_name descending' do
        expect( described_class.new('field_name desc').to_s ).to eq('ORDER field_name desc')
      end

      it 'uses field_name ascending' do
        expect( described_class.new('field_name asc').to_s ).to eq('ORDER field_name asc')
      end

      it 'uses @special_name' do
        expect( described_class.new('@special_name').to_s ).to eq('ORDER @special_name')
      end

      it 'uses :symbol' do
        pending 'Explore how to use symbol interpolation for ORDER clause'
        expect( described_class.new(:symbol).to_s ).to eq('ORDER :symbol')
      end

    end

    context 'with multiple values' do

      it 'ignores nil, nil' do
        expect( described_class.new(nil, nil).to_s ).to be_nil
      end

      it 'uses field1, field2' do
        expect( described_class.new('field1', 'field2').to_s ).to eq('ORDER field1, field2')
      end

      it 'uses field1, nil' do
        expect( described_class.new('field1', nil).to_s ).to eq('ORDER field1')
      end

      it 'uses nil, field2' do
        expect( described_class.new(nil, 'field2').to_s ).to eq('ORDER field2')
      end

    end

  end

end
