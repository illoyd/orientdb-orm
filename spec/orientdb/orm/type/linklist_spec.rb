require './spec/spec_helper.rb'

describe Orientdb::ORM::Type::LinkList do

  describe '#serialize' do

    it 'serializes nil to nil' do
      expect( subject.serialize(nil) ).to be_nil
    end

    it 'serializes a single RID array' do
      input = [ Orientdb::ORM::RID.new(1,2) ]
      expected = input
      expect( subject.serialize(input) ).to eq expected
    end

    it 'serializes a RID array' do
      input = [ Orientdb::ORM::RID.new(1,2), Orientdb::ORM::RID.new(2,3) ]
      expected = input
      expect( subject.serialize(input) ).to eq expected
    end

    it 'serializes an object that responds to #id' do
      rid = Orientdb::ORM::RID.new(1,2)
      input = [ ExampleVertex.new('@rid' => rid) ]
      expected = [ rid ]
      expect( subject.serialize(input) ).to eq expected
    end

    it 'serializes a mixed array of RIDs and objects that responds to #id' do
      rid = Orientdb::ORM::RID.new(1,2)
      input = [ ExampleVertex.new('@rid' => rid), rid ]
      expected = [ rid, rid ]
      expect( subject.serialize(input) ).to eq expected
    end

  end

  describe '#cast' do

    it 'returns nil for nil' do
      expect( subject.cast(nil) ).to be_nil
    end

    it 'returns [] for empty string' do
      expect( subject.cast('') ).to eq []
    end

    it 'returns [] for space string' do
      expect( subject.cast('    ') ).to eq []
    end

    it 'converts a single hash-RID' do
      input = '#1:2'
      expected = [ Orientdb::ORM::RID.new(1,2) ]
      expect( subject.cast(input) ).to eq expected
    end

    it 'converts a single hashless-RID' do
      input = '2:3'
      expected = [ Orientdb::ORM::RID.new(2,3) ]
      expect( subject.cast(input) ).to eq expected
    end

    it 'converts comma separated RID list' do
      input = '#2:3,3:4'
      expected = [ Orientdb::ORM::RID.new(2,3), Orientdb::ORM::RID.new(3,4) ]
      expect( subject.cast(input) ).to eq expected
    end

    it 'converts comma and space separated RID list' do
      input = '#2:3, 3:4'
      expected = [ Orientdb::ORM::RID.new(2,3), Orientdb::ORM::RID.new(3,4) ]
      expect( subject.cast(input) ).to eq expected
    end

    it 'converts a bracketed comma separated RID list' do
      input = '[#2:3,3:4]'
      expected = [ Orientdb::ORM::RID.new(2,3), Orientdb::ORM::RID.new(3,4) ]
      expect( subject.cast(input) ).to eq expected
    end

    it 'converts a bracketed comma and space separated RID list' do
      input = '[ #2:3, 3:4 ]'
      expected = [ Orientdb::ORM::RID.new(2,3), Orientdb::ORM::RID.new(3,4) ]
      expect( subject.cast(input) ).to eq expected
    end

  end

end