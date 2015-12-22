require './spec/spec_helper.rb'

describe URI::OrientDB do
  
  context 'with a full URL', focus: true do
    let(:url) { 'orientdb://user:password@host:1234/database' }
    subject   { URI(url) }
    
    its(:scheme)   { should eq('orientdb') }

    its(:host)     { should eq('host') }
    its(:port)     { should eq(1234) }
    its(:ssl?)     { should be(false) }

    its(:user)     { should eq('user') }
    its(:password) { should eq('password') }

    its(:database) { should eq('database') }
  end

  context 'without a port' do
    let(:url) { 'orientdb://user:password@host/database' }
    subject   { URI(url) }
    
    its(:scheme)   { should eq('orientdb') }

    its(:host)     { should eq('host') }
    its(:port)     { should eq(2480) }
    its(:ssl?)     { should be(false) }

    its(:user)     { should eq('user') }
    its(:password) { should eq('password') }

    its(:database) { should eq('database') }
  end

  context 'with a very simple URL' do
    let(:url) { 'orientdb://host' }
    subject   { URI(url) }
    
    its(:scheme)   { should eq('orientdb') }

    its(:host)     { should eq('host') }
    its(:port)     { should eq(2424) }
    its(:ssl?)     { should be(false) }

    its(:user)     { should be_nil }
    its(:password) { should be_nil }

    its(:database) { should be_nil }
  end

end
