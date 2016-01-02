require './spec/spec_helper.rb'

describe Orientdb::ORM::Document do
  let(:old_name) { 'Old' }
  let(:new_name) { 'New' }
  subject { ExampleVertex.new(name: old_name) }
  
  it 'detects change via attribute assignment' do
    expect{ subject.name = new_name }.to change(subject, :changed).from([]).to(['name'])
  end

  it 'detects change via hash assignment' do
    expect{ subject[:name] = new_name }.to change(subject, :changed).from([]).to(['name'])
  end

end