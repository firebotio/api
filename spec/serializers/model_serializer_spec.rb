require "rails_helper"

describe ModelSerializer do
  let(:hash) { serializer.new(model).serializable_hash }
  let(:model) do
    Model.new(first_name: "first_name",
              last_name: "last_name",
              id: 1,
              object_type: "Test"
    )
  end
  let(:schema) { double "schema", keys: %i(first_name last_name id) }
  let(:serializer) do
    s = ModelSerializer
    s.schema = schema
    s
  end

  it "should have the correct keys and values" do
    expect(hash[:first_name]).to eq "first_name"
    expect(hash[:last_name]).to eq "last_name"
    expect(hash[:id]).to eq 1.to_s
  end
end
