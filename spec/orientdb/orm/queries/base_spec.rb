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

end
