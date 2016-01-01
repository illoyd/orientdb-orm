require './spec/spec_helper.rb'

describe URI::OrientDB do
  
  context 'with a full URL' do
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
    its(:port)     { should eq(2480) }
    its(:ssl?)     { should be(false) }

    its(:user)     { should be_nil }
    its(:password) { should be_nil }

    its(:database) { should be_nil }
  end
  
  describe '#database=' do
    let(:url) { 'orientdb://user:password@host/database' }
    subject   { URI(url) }
    
    it 'changes database to given value' do
      expect{ subject.database = 'test_database' }.to change(subject, :database).from('database').to('test_database')
    end
    
    it 'reflects database change to given value in URL' do
      expect{ subject.database = 'test_database' }.to change(subject, :to_s).from(url).to('orientdb://user:password@host/test_database')
    end
    
    it 'changes database to nil' do
      expect{ subject.database = nil }.to change(subject, :database).from('database').to(nil)
    end
    
    it 'reflects database change to nil in URL' do
      expect{ subject.database = nil }.to change(subject, :to_s).from(url).to('orientdb://user:password@host')
    end
  end

end
