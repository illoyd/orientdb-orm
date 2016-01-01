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
      expect( described_class.new('field', 'x', accessor: :another).accessor ).to eq(:another)
    end
    
    it 'defaults to field if nil' do
      expect( described_class.new(:field, 'x', accessor: nil).accessor ).to eq(:field)
    end
    
    it 'defaults to field if not specified' do
      expect( described_class.new(:field, 'x').accessor ).to eq(:field)
    end
  end
  
  describe '#field_type' do
    it 'accepts a string' do
      expect( described_class.new('field', 'x').field_type ).to eq('x')
    end
    
    it 'defaults to nil if not specified' do
      expect( described_class.new(:field).field_type ).to be_nil
    end
  end
  
  describe '#default' do
    it 'accepts a default option' do
      expect( described_class.new('field', 'type', default: 'bob').default ).to eq('bob')
    end
    
    it 'accepts a nil option' do
      expect( described_class.new(:field, 'type', default: nil).default ).to be_nil
    end
    
    it 'defaults to nil if not specified' do
      expect( described_class.new(:field, 'type').default ).to be_nil
    end
  end
  
  describe '#validates_options' do
    it 'accepts a validates option' do
      expect( described_class.new('field', 'type', validates: { presence: true }).validates_options ).to eq({presence: true})
    end
    
    it 'accepts a nil option' do
      expect( described_class.new(:field, 'type', validates: nil).validates_options ).to be_nil
    end
    
    it 'defaults to nil if not specified' do
      expect( described_class.new(:field, 'type').validates_options ).to be_nil
    end
  end
  

end
