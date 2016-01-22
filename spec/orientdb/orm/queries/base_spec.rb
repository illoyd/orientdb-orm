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

    it 'converts nil to NULL' do
      expect( described_class.sanitize_parameter(nil) ).to eq('NULL')
    end

    it 'sanitises Arrays' do
      param = [ 'string', 1, nil ]
      expect( described_class.sanitize_parameter(param) ).to eq([ 'string', 1, 'NULL' ])
    end

    it 'sanitises Hashes' do
      param = { 'a' => 'string', 'b' => 1, c: nil }
      expect( described_class.sanitize_parameter(param) ).to eq({ 'a' => 'string', 'b' => 1, c: 'NULL' })
    end

    it 'sanitises Sets' do
      param = Set.new([ 'string', 1, nil ])
      expect( described_class.sanitize_parameter(param) ).to match_array([ 'string', 1, 'NULL' ])
    end

  end

end
