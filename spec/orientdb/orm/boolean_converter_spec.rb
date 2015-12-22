require './spec/spec_helper.rb'

describe Orientdb::ORM::BooleanConverter do
  it { expect( described_class.call('t') ).to be true }
  it { expect( described_class.call('true') ).to be true }
  it { expect( described_class.call('y') ).to be true }
  it { expect( described_class.call('yes') ).to be true }
  it { expect( described_class.call('1') ).to be true }
  it { expect( described_class.call(1) ).to be true }
  it { expect( described_class.call(true) ).to be true }

  it { expect( described_class.call('f') ).to be false }
  it { expect( described_class.call('false') ).to be false }
  it { expect( described_class.call('n') ).to be false }
  it { expect( described_class.call('no') ).to be false }
  it { expect( described_class.call('0') ).to be false }
  it { expect( described_class.call(0) ).to be false }
  it { expect( described_class.call(false) ).to be false }

  it { expect( described_class.call(nil) ).to be false }
end
