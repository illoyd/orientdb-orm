require './spec/spec_helper.rb'

describe Orientdb::ORM::Quoting do

  class QuotingClass
    include Orientdb::ORM::Quoting
  end

  subject{ QuotingClass.new }

  describe '#quote' do

    it 'quotes a string' do
      expect( subject.class.quote('hello') ).to eq '"hello"'
    end

    it 'quotes a symbol' do
      expect( subject.class.quote(:hello) ).to eq '"hello"'
    end

    it 'quotes a RID' do
      expect( subject.class.quote( Orientdb::ORM::RID.new(1,2) ) ).to eq "#1:2"
    end

    it 'quotes an integer' do
      expect( subject.class.quote(5) ).to eq "5"
    end

    it 'quotes a float' do
      expect( subject.class.quote(4.312) ).to eq "DECIMAL(4.312)"
    end

    it 'quotes a decimal' do
      expect( subject.class.quote( BigDecimal.new('5.21') ) ).to eq "DECIMAL(5.21)"
    end

    it 'quotes TRUE' do
      expect( subject.class.quote(true) ).to eq "TRUE"
    end

    it 'quotes FALSE' do
      expect( subject.class.quote(false) ).to eq "FALSE"
    end

    it 'quotes NIL' do
      expect( subject.class.quote(nil) ).to eq "NULL"
    end

    it 'quotes today' do
      today = Date.today
      expect( subject.class.quote(today) ).to eq "DATE('#{ today.strftime('%Y-%m-%d %H:%M:%S') }')"
    end

    it 'quotes now' do
      now = Time.now
      expect( subject.class.quote(now) ).to eq "DATE('#{ now.strftime('%Y-%m-%d %H:%M:%S') }')"
    end

    it 'quotes date' do
      today = Date.new(2016, 1, 22)
      expect( subject.class.quote(today) ).to eq "DATE('2016-01-22 00:00:00')"
    end

    it 'quotes date time' do
      now = Time.new(2016, 1, 22, 20, 11, 35)
      expect( subject.class.quote(now) ).to eq "DATE('2016-01-22 20:11:35')"
    end

    it 'quotes Arrays' do
      param = [ 'string', 1, nil ]
      expect( subject.class.quote(param) ).to eq('["string",1,NULL]')
    end

    it 'quotes Link Array' do
      param = [ Orientdb::ORM::RID.new(1,2), Orientdb::ORM::RID.new(1,2) ]
      expect( subject.class.quote(param) ).to eq('[#1:2,#1:2]')
    end

    it 'quotes Hashes' do
      param = { 'a' => 'string', 'b' => 1, c: nil }
      expect( subject.class.quote(param) ).to eq('{"a":"string","b":1,"c":NULL}')
    end

    it 'quotes Sets' do
      param = Set.new([ 'string', 1, 1, 'string', nil, nil ])
      expect( subject.class.quote(param) ).to eq('["string",1,NULL]')
    end

    it 'quotes Link Set' do
      param = Set.new([ Orientdb::ORM::RID.new(1,2), Orientdb::ORM::RID.new(1,2) ])
      expect( subject.class.quote(param) ).to eq('[#1:2]')
    end

    it 'quotes Classes' do
      expect( subject.class.quote(Orientdb::ORM::V) ).to eq '"Orientdb::ORM::V"'
    end

    it 'throws error object' do
      expect{ subject.class.quote(Object.new) }.to raise_error(TypeError)
    end

  end #quote

end # Orientdb::ORM::Quoting