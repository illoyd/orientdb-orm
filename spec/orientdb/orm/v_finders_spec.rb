require './spec/spec_helper.rb'

describe Orientdb::ORM::Finders, :with_database do

  class OUser < Orientdb::ORM::V; end

  describe OUser do

    describe '.all' do

      it 'returns a Result object' do
        expect( described_class.all ).to be_an(Orientdb::ORM::Queries::Result)
      end

      it 'returns all objects' do
        expect( described_class.all.count ).to eq(3)
      end

      it 'returns only OUser objects' do
        expect( described_class.all.map { |obj| obj.class } ).to match_array([ OUser, OUser, OUser ])
      end

      it 'returns expected RIDs' do
        expect( described_class.all.map { |obj| obj._rid.to_s } ).to match_array([ '#5:0', '#5:1', '#5:2' ])
      end

    end

    describe '.where' do

      context 'with a known OUser' do
        let(:query) { {'@rid' => Orientdb::ORM::RID.new(5,0)} }

        context 'with RID' do
          it 'returns an array of objects' do
            expect( described_class.where(query) ).to be_an(Orientdb::ORM::Queries::Result)
          end

          it 'returns only one object' do
            expect( described_class.where(query).count ).to eq(1)
          end

          it 'returns only OUser objects' do
            expect( described_class.where(query).map { |obj| obj.class } ).to match_array([ OUser ])
          end
        end

        context 'with Name' do
          let(:query) { {'name' => 'admin'} }

          it 'returns an array of objects' do
            expect( described_class.where(query) ).to be_an(Orientdb::ORM::Queries::Result)
          end

          it 'returns only one objects' do
            expect( described_class.where(query).count ).to eq(1)
          end

          it 'returns only OUser objects' do
            expect( described_class.where(query).map { |obj| obj.class } ).to match_array([ OUser ])
          end
        end
      end

      context 'with a known non-object' do
        it 'returns nil with unknown RID' do
          expect( described_class.find_by('@rid' => '#5000:0') ).to be_nil
        end

        it 'returns nil with unknown name' do
          expect( described_class.find_by('name' => 'bob') ).to be_nil
        end
      end

    end # .where

    describe '.find_by' do

      context 'with a known OUser' do
        it 'finds the OUser by RID' do
          expect( described_class.find_by('@rid' => '#5:0') ).to be_a(described_class)
        end

        it 'finds the OUser by name' do
          expect( described_class.find_by('name' => 'admin') ).to be_a(described_class)
        end
      end

      context 'with a known non-object' do
        it 'returns nil with unknown RID' do
          expect( described_class.find_by('@rid' => '#5000:0') ).to be_nil
        end

        it 'returns nil with unknown name' do
          expect( described_class.find_by('name' => 'bob') ).to be_nil
        end
      end

    end # .find_by

    describe '.find' do

      context 'with a known OUser' do
        it 'finds the OUser' do
          expect( described_class.find('#5:0') ).to be_a(described_class)
        end
      end

      context 'with a known non-object' do
        it 'returns nil' do
          expect( described_class.find('#5000:0') ).to be_nil
        end
      end

    end #.find_by_id

  end

end