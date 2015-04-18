require "rails_helper"

describe ParseObject do
  let(:attributes) do
    {
      access_token: AccessToken.new,
      object_type:  "Test",
      schema:       schema
    }
  end
  let(:schema) { Schema.new }

  subject { described_class.new attributes }

  describe "#assign_attributes" do
    let(:first_name) { "new_first_name" }
    let(:last_name)  { "new_last_name" }
    let(:object) do
      {
        "first_name" => "first_name",
        "last_name"  => "last_name"
      }
    end

    before do
      allow(schema).to receive(:model).and_return(
        {
          "schema" => {
            first_name: {
              type: "string"
            },
            last_name: {
              type: "string"
            }
          }.to_json
        }
      )
    end

    it "should update the attributes of the object" do
      obj = subject.assign_attributes object, {
        "first_name" => first_name,
        "last_name"  => last_name
      }
      expect(obj["first_name"]).to eq first_name
      expect(obj["last_name"]).to eq last_name
    end
  end
end
