require 'spec_helper'

shared_examples 'a persistable object' do

  describe 'handles round trip persistance' do

    values = {
      string:    'hello',
      integer:   5,
      float:     1.2,
      decimal:   BigDecimal.new('2.3'),
      link:      Orientdb::ORM::RID.new(5, 0),
      date:      Date.new(2016, 1, 23),
      datetime:  Time.new(2016, 1, 23, 8, 22, 54),
      linklist:  [ Orientdb::ORM::RID.new(5, 0), Orientdb::ORM::RID.new(5, 1) ],
      linkset:   Set.new([ Orientdb::ORM::RID.new(5, 0), Orientdb::ORM::RID.new(5, 1) ]),
      linkmap:   { hello: Orientdb::ORM::RID.new(5, 0) },
      fieldtypes: Orientdb::ORM::FieldType.new({ '@rid' => Orientdb::ORM::LinkType }),
    }

    values.each do |k,v|

      it "persists a #{ k }" do
        # Define and assign attribute
        subject.schema << Orientdb::ORM::AttributeDefinition.new(:value, k)
        subject[:value] = v
        expect{ subject.save! }.to change(subject, :persisted?).to(true)

        # Reload subject
        subject.reload!

        # Check that value is returned
        expect( subject.value ).to match v
      end

    end

    it 'persists a string with line breaks' do
      subject.schema << Orientdb::ORM::AttributeDefinition.new(:value, :string)
      value = 'Hello!
      I am a multiline entry.'
      subject[:value] = value

      # Save subject
      expect{ subject.save! }.to change(subject, :persisted?).to(true)

      # Reload subject
      subject.reload!

      # Check that value is returned
      expect( subject.value ).to match value
    end

    it 'persists a string with single quotes' do
      subject.schema << Orientdb::ORM::AttributeDefinition.new(:value, :string)
      value = 'Hello! I contain \'single quotes\'.'
      subject[:value] = value

      # Save subject
      expect{ subject.save! }.to change(subject, :persisted?).to(true)

      # Reload subject
      subject.reload!

      # Check that value is returned
      expect( subject.value ).to match value
    end

    it 'persists a string with double quotes' do
      subject.schema << Orientdb::ORM::AttributeDefinition.new(:value, :string)
      value = 'Hello! I contain "double quotes".'
      subject[:value] = value

      # Save subject
      expect{ subject.save! }.to change(subject, :persisted?).to(true)

      # Reload subject
      subject.reload!

      # Check that value is returned
      expect( subject.value ).to match value
    end

  end

end