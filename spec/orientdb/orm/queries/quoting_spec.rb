require './spec/spec_helper.rb'

describe Orientdb::ORM::Quoting do

  class QuotingClass
    include Orientdb::ORM::Quoting
  end

  subject{ QuotingClass.new }

  describe '#quote' do

    it 'quotes a string' do
      expect( subject.quote('hello') ).to eq "'hello'"
    end

    it 'quotes a symbol' do
      expect( subject.quote(:hello) ).to eq "'hello'"
    end

    it 'quotes an integer' do
      expect( subject.quote(5) ).to eq "5"
    end

    it 'quotes a RID' do
      expect( subject.quote( Orientdb::ORM::RID.new(1,2) ) ).to eq "#1:2"
    end

    it 'quotes a decimal' do
      expect( subject.quote( BigDecimal.new('5.21') ) ).to eq "5.21"
    end

    it 'quotes TRUE' do
      expect( subject.quote(true) ).to eq "TRUE"
    end

    it 'quotes FALSE' do
      expect( subject.quote(false) ).to eq "FALSE"
    end

    it 'quotes NIL' do
      expect( subject.quote(nil) ).to eq "NULL"
    end

    it 'quotes today' do
      today = Date.today
      expect( subject.quote(today) ).to eq today.to_time.getutc.to_i.to_s
    end

    it 'quotes now' do
      now = Time.now
      expect( subject.quote(now) ).to eq now.getutc.to_i.to_s
    end

    it 'quotes date' do
      today = Date.new(2016, 1, 22)
      expect( subject.quote(today) ).to eq '1453420800'
    end

    it 'quotes date time' do
      now = Time.new(2016, 1, 22, 20, 11, 35)
      expect( subject.quote(now) ).to eq '1453493495'
    end

  end #quote

end # Orientdb::ORM::Quoting