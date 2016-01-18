require './spec/spec_helper.rb'

describe Orientdb::ORM::RID do

  context 'with a valid, persisted RID' do
    subject { Orientdb::ORM::RID.new( 2, 1 ) }
    its(:collection)  { should eq(2) }
    its(:position)    { should eq(1) }
    its('persisted?') { should be true }
    its('valid?')     { should be true }
    its('to_s')       { should eq('#2:1') }
    its('to_param')   { should eq('2:1') }

    it 'equals #2:1' do
      expect( subject ).to eq('#2:1')
    end

    it 'equals 2:1' do
      expect( subject ).to eq('2:1')
    end

    it 'equals RID<#2:1>' do
      expect( subject ).to eq(Orientdb::ORM::RID.new(2,1))
    end

    it 'equals itself' do
      expect( subject ).to eq(subject)
    end

    it 'does not equal #1:2' do
      expect( subject ).not_to eq('#1:2')
    end

    it 'does not equal 1:2' do
      expect( subject ).not_to eq('1:2')
    end

    it 'does not equal RID<#1:2>' do
      expect( subject ).not_to eq(Orientdb::ORM::RID.new(1,2))
    end

  end

  context 'Comparable' do
    subject { Orientdb::ORM::RID.new(2,3) }

    it 'is equal to #2:3' do
      other = Orientdb::ORM::RID.new(2,3)
      expect( subject <=> other ).to eq 0
    end

    it 'is greater than #2:1' do
      other = Orientdb::ORM::RID.new(2,2)
      expect( subject <=> other ).to eq 1
    end

    it 'is less than #2:4' do
      other = Orientdb::ORM::RID.new(2,4)
      expect( subject <=> other ).to eq -1
    end

    it 'is greater than #1:1' do
      other = Orientdb::ORM::RID.new(1,1)
      expect( subject <=> other ).to eq 1
    end

    it 'is less than #3:1' do
      other = Orientdb::ORM::RID.new(3,1)
      expect( subject <=> other ).to eq -1
    end

  end

  context 'with an invalid collection RID' do
    subject { Orientdb::ORM::RID.new( nil, 1 ) }
    its(:collection)  { should be_nil }
    its(:position)    { should eq(1) }
    its('persisted?') { should be false }
    its('valid?')     { should be false }
    its('to_s')       { should eq('#NIL:1') }
  end

  context 'with an invalid position RID' do
    subject { Orientdb::ORM::RID.new( 1, nil ) }
    its(:collection)  { should eq(1) }
    its(:position)    { should be_nil }
    its('persisted?') { should be false }
    its('valid?')     { should be false }
    its('to_s')       { should eq('#1:NIL') }
  end

  context 'with an invalid collection and position RID' do
    subject { Orientdb::ORM::RID.new( nil, nil ) }
    its(:collection)  { should be_nil }
    its(:position)    { should be_nil }
    its('persisted?') { should be false }
    its('valid?')     { should be false }
    its('to_s')       { should eq('#NIL:NIL') }
  end

  context 'with a valid, un-persisted RID (collection defined, but position not)' do
    subject { Orientdb::ORM::RID.new( 1, -1 ) }
    its(:collection)  { should eq(1) }
    its(:position)    { should eq(-1) }
    its('persisted?') { should be false }
    its('valid?')     { should be true }
    its('to_s')       { should eq('#1:-1') }

    it 'equals #1:-1' do
      expect( subject ).to eq('#1:-1')
    end

    it 'equals 1:-1' do
      expect( subject ).to eq('1:-1')
    end

    it 'equals RID<#1:-1>' do
      expect( subject ).to eq(Orientdb::ORM::RID.new(1,-1))
    end

    it 'equals itself' do
      expect( subject ).to eq(subject)
    end
  end

end
