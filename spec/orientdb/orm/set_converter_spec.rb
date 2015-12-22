require './spec/spec_helper.rb'

describe Orientdb::ORM::SetConverter do

  it { expect( described_class.call([1,2,3]) ).to      be_a(Set) }
  it { expect( described_class.call([1,2,3]) ).to      match_array([1,2,3]) }
  it { expect( described_class.call([2,1,3]) ).to      match_array([1,2,3]) }
  it { expect( described_class.call([3,2,1]) ).to      match_array([1,2,3]) }

  it { expect( described_class.call([1,1,1]) ).to      be_a(Set) }
  it { expect( described_class.call([1,1,1]) ).to      match_array([1]) }
  it { expect( described_class.call([2,1,1]) ).to      match_array([1,2]) }
  it { expect( described_class.call([3,2,3]) ).to      match_array([2,3]) }

  it { expect( described_class.call('') ).to      be_a(Set) }
  it { expect( described_class.call('') ).to      be_empty }

  it { expect( described_class.call('   ') ).to   be_a(Set) }
  it { expect( described_class.call('   ') ).to   be_empty }

end
