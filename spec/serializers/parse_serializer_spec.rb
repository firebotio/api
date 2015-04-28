require "rails_helper"

describe ParseSerializer do
  let(:date) { Time.now }
  let(:hash) { serializer.new(object).serializable_hash }
  let(:object) do
    {
      "createdAt"  => date,
      "first_name" => "first_name",
      "last_name"  => "last_name",
      "objectId"   => "1",
      "updatedAt"  => date
    }
  end
  let(:schema) { double "schema", keys: %i(first_name last_name id) }
  let(:serializer) do
    s = described_class
    s.schema = schema
    s
  end

  it "should have the correct keys and values" do
    expect(hash[:created_at]).to eq date
    expect(hash[:first_name]).to eq "first_name"
    expect(hash[:last_name]).to eq "last_name"
    expect(hash[:id]).to eq "1"
    expect(hash[:updated_at]).to eq date
  end
end
