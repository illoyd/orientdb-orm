require './spec/spec_helper.rb'

describe Orientdb::ORM::Quoting do

  class QuotingClass
    include Orientdb::ORM::Quoting
  end

  subject{ QuotingClass.new }

  describe '#quote' do

    it 'quotes a string' do
      expect( subject.class.quote('hello') ).to eq "'hello'"
    end

    it 'quotes a symbol' do
      expect( subject.class.quote(:hello) ).to eq "'hello'"
    end

    it 'quotes an integer' do
      expect( subject.class.quote(5) ).to eq "5"
    end

    it 'quotes a RID' do
      expect( subject.class.quote( Orientdb::ORM::RID.new(1,2) ) ).to eq "#1:2"
    end

    it 'quotes a decimal' do
      expect( subject.class.quote( BigDecimal.new('5.21') ) ).to eq "5.21"
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
      expect( subject.class.quote(today) ).to eq today.to_time.getutc.to_i.to_s
    end

    it 'quotes now' do
      now = Time.now
      expect( subject.class.quote(now) ).to eq now.getutc.to_i.to_s
    end

    it 'quotes date' do
      today = Date.new(2016, 1, 22)
      expect( subject.class.quote(today) ).to eq '1453420800'
    end

    it 'quotes date time' do
      now = Time.new(2016, 1, 22, 20, 11, 35)
      expect( subject.class.quote(now) ).to eq '1453493495'
    end

    it 'quotes Arrays' do
      param = [ 'string', 1, nil ]
      expect( subject.class.quote(param) ).to eq([ "'string'", '1', 'NULL' ])
    end

    it 'quotes Hashes' do
      param = { 'a' => 'string', 'b' => 1, c: nil }
      expect( subject.class.quote(param) ).to eq({ 'a' => "'string'", 'b' => '1', c: 'NULL' })
    end

    it 'quotes Sets' do
      param = Set.new([ 'string', 1, nil ])
      expect( subject.class.quote(param) ).to match_array([ "'string'", '1', 'NULL' ])
    end

  end #quote

end # Orientdb::ORM::Quoting