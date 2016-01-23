describe Orientdb::ORM::Type::Link do

  describe '#serialize' do

    it 'converts RID(1,2)' do
      expect( subject.serialize(Orientdb::ORM::RID.new(1,2)) ).to eq Orientdb::ORM::RID.new(1,2)
    end

    it 'does not cast an object that responds to #id' do
      v = ExampleVertex.new( '@rid' => Orientdb::ORM::RID.new(3,4) )
      expect( subject.serialize(v) ).to eq Orientdb::ORM::RID.new(3,4)
    end

  end

  describe '#cast' do

    it 'returns nil for nil' do
      expect( subject.cast(nil) ).to be_nil
    end

    it 'returns nil for empty string' do
      expect( subject.cast('') ).to be_nil
    end

    it 'returns nil for space string' do
      expect( subject.cast('    ') ).to be_nil
    end

    it 'casts a string with hash prefix' do
      expect( subject.cast('#1:2') ).to eq Orientdb::ORM::RID.new(1,2)
    end

    it 'casts a string without a hash prefix' do
      expect( subject.cast('2:3') ).to eq Orientdb::ORM::RID.new(2,3)
    end

    it 'casts a string with -1:-1' do
      expect( subject.cast('-1:-1') ).to eq Orientdb::ORM::RID.new(-1,-1)
    end

    it 'does not cast an object that responds to #id' do
      v = ExampleVertex.new( '@rid'=>Orientdb::ORM::RID.new(3,4) )
      expect( subject.cast(v) ).to eq v
    end

  end

end