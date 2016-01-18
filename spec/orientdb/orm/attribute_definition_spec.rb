require './spec/spec_helper.rb'

describe Orientdb::ORM::AttributeDefinition do

  describe '#name' do
    it 'accepts a string' do
      expect( described_class.new('field').name ).to eq('field')
    end

    it 'accepts a symbol and converts to string' do
      expect( described_class.new(:field).name ).to eq('field')
    end
  end

  describe '#accessor' do
    it 'accepts an accessor option' do
      expect( described_class.new('field', :link, accessor: :another).accessor ).to eq(:another)
    end

    it 'defaults to field if nil' do
      expect( described_class.new(:field, :link, accessor: nil).accessor ).to eq(:field)
    end

    it 'defaults to field if not specified' do
      expect( described_class.new(:field, :link).accessor ).to eq(:field)
    end
  end

  describe '#field_type' do
    it 'accepts a string' do
      expect( described_class.new('field', :link).type ).to be_a(Orientdb::ORM::Type::RID)
    end

    it 'defaults to value if not specified' do
      expect( described_class.new(:field).type ).to be_a(ActiveModel::Type::Value)
    end
  end

  describe '#default' do
    it 'accepts a default option' do
      expect( described_class.new('field', :value, default: 'bob').default ).to eq('bob')
    end

    it 'accepts a nil option' do
      expect( described_class.new(:field, :value, default: nil).default ).to be_nil
    end

    it 'defaults to nil if not specified' do
      expect( described_class.new(:field, :value).default ).to be_nil
    end
  end

  describe '#validates_options' do
    it 'accepts a validates option' do
      expect( described_class.new('field', :value, validates: { presence: true }).validates_options ).to eq({presence: true})
    end

    it 'accepts a nil option' do
      expect( described_class.new(:field, :value, validates: nil).validates_options ).to be_nil
    end

    it 'defaults to nil if not specified' do
      expect( described_class.new(:field, :value).validates_options ).to be_nil
    end
  end


end
