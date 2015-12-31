require './spec/spec_helper.rb'

describe Orientdb::ORM::Queries::Base do
  
  describe '.target_rid_for' do
    
    it 'converts a Vertex to RID string' do
      obj = ExampleVertex.new
      expect( described_class.target_rid_for(obj) ).to eq(obj._rid.to_s)
    end
    
    it 'converts a RID to RID string' do
      obj = Orientdb::ORM::RID.new(3, 4)
      expect( described_class.target_rid_for(obj) ).to eq(obj.to_s)
    end
    
    it 'leaves a string alone' do
      obj = "#2:3"
      expect( described_class.target_rid_for(obj) ).to eq("(#{ obj })")
    end
    
  end

  describe '.sanitize_parameter' do
    
    it 'wraps a string in quotes' do
      expect( described_class.sanitize_parameter('string') ).to eq('"string"')
    end

    it 'wraps a string in quotes and ignores single quotes' do
      expect( described_class.sanitize_parameter('str\'ing') ).to eq('"str\'ing"')
    end

    it 'wraps a string in quotes and escapes double quotes' do
      expect( described_class.sanitize_parameter('string "another" string') ).to eq('"string \"another\" string"')
    end

    it 'does not wrap a RID' do
      rid = Orientdb::ORM::RID.new( 2, 3 )
      expect( described_class.sanitize_parameter(rid) ).to eq('#2:3')
    end

    it 'converts nil to NULL' do
      expect( described_class.sanitize_parameter(nil) ).to eq('NULL')
    end
    
    it 'sanitises Arrays' do
      param = [ 'string', 1, nil, Orientdb::ORM::RID.new(2,3) ]
      expect( described_class.sanitize_parameter(param) ).to eq(['"string"', 1, 'NULL', '#2:3'])
    end

    it 'sanitises Hashes' do
      param = { 'a' => 'string', 'b' => 1, c: nil, d: Orientdb::ORM::RID.new(2,3) }
      expect( described_class.sanitize_parameter(param) ).to eq({ 'a' => '"string"', 'b' => 1, c: 'NULL', d: '#2:3' })
    end

    it 'sanitises Sets' do
      param = Set.new([ 'string', 1, nil, Orientdb::ORM::RID.new(2,3) ])
      expect( described_class.sanitize_parameter(param) ).to match_array(['"string"', 1, 'NULL', '#2:3'])
    end

  end

end
