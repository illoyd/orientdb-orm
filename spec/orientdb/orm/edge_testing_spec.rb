require './spec/spec_helper.rb'

describe 'Edge Detection', :with_database do

  it 'adds edge OUT attributes to vertices' do
    v1 = ExampleVertex.new( label: 'V1' )
    v2 = ExampleVertex.new( label: 'V2' )

    expect{ v1.save }.not_to raise_error
    expect( v1.persisted? ).to be true
    expect{ v2.save }.not_to raise_error
    expect( v2.persisted? ).to be true

    e1 = ExampleEdge.new(in: v1, out: v2)
    expect( e1.in ).to eq(v1)
    expect( e1.out ).to eq(v2)
    expect{ e1.save }.not_to raise_error
    expect( e1.in ).to be_a(Orientdb::ORM::RID)
    expect( e1.out ).to be_a(Orientdb::ORM::RID)

    v1a = ExampleVertex.find_by(label: 'V1')
    expect( v1a ).not_to be_nil
    expect( v1a._field_types['in_ExampleEdge'] ).to eq(Orientdb::ORM::LinkBagType)
    expect( v1a['in_ExampleEdge'].first ).to be_a(Orientdb::ORM::RID)
    expect( v1a['in_ExampleEdge'].first ).to eq(e1._rid)
    expect( v1a['out_ExampleEdge'] ).to be_nil

    v2a = ExampleVertex.find_by(label: 'V2')
    expect( v2a ).not_to be_nil
    expect( v2a._field_types['out_ExampleEdge'] ).to eq(Orientdb::ORM::LinkBagType)
    expect( v2a['out_ExampleEdge'].first ).to be_a(Orientdb::ORM::RID)
    expect( v2a['out_ExampleEdge'].first ).to eq(e1._rid)
    expect( v2a['in_ExampleEdge'] ).to be_nil
  end

end