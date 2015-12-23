require './spec/spec_helper.rb'

describe Orientdb::ORM::RID do

  context 'with a valid, persisted RID' do
    subject { Orientdb::ORM::RID.new( 1, 0 ) }
    its(:collection)  { should eq(1) }
    its(:position)    { should eq(0) }
    its('persisted?') { should be true }
    its('valid?')     { should be true }
    its('to_s')       { should eq('#1:0') }
    its('to_short_s') { should eq('1:0') }

    it 'equals #1:0' do
      expect( subject ).to eq('#1:0')
    end

    it 'equals 1:0' do
      expect( subject ).to eq('1:0')
    end

    it 'equals RID<#1:0>' do
      expect( subject ).to eq(Orientdb::ORM::RID.new(1,0))
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

  describe '.call' do

    context 'with RID<2:3>' do
      let(:rid) { Orientdb::ORM::RID.new(2,3) }
      subject   { Orientdb::ORM::RID.call(rid) }
      its(:collection)  { should eq(2) }
      its(:position)    { should eq(3) }
      its('persisted?') { should be true }
      its('valid?')     { should be true }
      it 'returns the input RID' do
        expect( subject).to equal(rid)
      end
    end

    context 'with #2:3' do
      subject { Orientdb::ORM::RID.call('#2:3') }
      its(:collection)  { should eq(2) }
      its(:position)    { should eq(3) }
      its('persisted?') { should be true }
      its('valid?')     { should be true }
    end

    context 'with 3:4' do
      subject { Orientdb::ORM::RID.call('3:4') }
      its(:collection)  { should eq(3) }
      its(:position)    { should eq(4) }
      its('persisted?') { should be true }
      its('valid?')     { should be true }
    end

    context 'with -1:0' do
      subject { Orientdb::ORM::RID.call('-1:0') }
      its(:collection)  { should eq(-1) }
      its(:position)    { should eq(0) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with 7:-1' do
      subject { Orientdb::ORM::RID.call('7:-1') }
      its(:collection)  { should eq(7) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with "  8:-1   "' do
      subject { Orientdb::ORM::RID.call('  8:-1   ') }
      its(:collection)  { should eq(8) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with "#9 : -1"' do
      subject { Orientdb::ORM::RID.call('#9 : -1') }
      its(:collection)  { should eq(-1) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with bob' do
      subject { Orientdb::ORM::RID.call('bob') }
      its(:collection)  { should eq(-1) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with nil' do
      subject { Orientdb::ORM::RID.call(nil) }
      its(:collection)  { should eq(-1) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with empty string' do
      subject { Orientdb::ORM::RID.call('') }
      its(:collection)  { should eq(-1) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

    context 'with spaced string' do
      subject { Orientdb::ORM::RID.call('     ') }
      its(:collection)  { should eq(-1) }
      its(:position)    { should eq(-1) }
      its('persisted?') { should be false }
      its('valid?')     { should be true }
    end

  end

end
