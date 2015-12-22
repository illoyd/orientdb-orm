require './spec/spec_helper.rb'

describe Orientdb::ORM::FloatConverter do

  it { expect( described_class.call('1') ).to     eq(1.0) }
  it { expect( described_class.call('1.0') ).to   eq(1.0) }
  it { expect( described_class.call('01.0') ).to  eq(1.0) }
  it { expect( described_class.call('01.00') ).to eq(1.0) }

  it { expect( described_class.call('-1') ).to     eq(-1.0) }
  it { expect( described_class.call('-1.0') ).to   eq(-1.0) }
  it { expect( described_class.call('-01.0') ).to  eq(-1.0) }
  it { expect( described_class.call('-01.00') ).to eq(-1.0) }

  it { expect( described_class.call('123.456') ).to eq(123.456) }

  it { expect( described_class.call('f') ).to     be_nil }
  it { expect( described_class.call('') ).to      be_nil }
  it { expect( described_class.call('   ') ).to   be_nil }

end
