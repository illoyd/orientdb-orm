require './spec/spec_helper.rb'

describe Orientdb::ORM::IntegerConverter do

  it { expect( described_class.call('1') ).to     eq(1) }
  it { expect( described_class.call('01') ).to    eq(1) }
  it { expect( described_class.call('1.0') ).to   be_nil }
  it { expect( described_class.call('01.0') ).to  be_nil }
  it { expect( described_class.call('01.00') ).to be_nil }

  it { expect( described_class.call('-1') ).to     eq(-1) }
  it { expect( described_class.call('-01') ).to    eq(-1) }
  it { expect( described_class.call('-1.0') ).to   be_nil }
  it { expect( described_class.call('-01.0') ).to  be_nil }
  it { expect( described_class.call('-01.00') ).to be_nil }

  it { expect( described_class.call('123.456') ).to be_nil }

  it { expect( described_class.call('f') ).to     be_nil }
  it { expect( described_class.call('') ).to      be_nil }
  it { expect( described_class.call('   ') ).to   be_nil }

end
