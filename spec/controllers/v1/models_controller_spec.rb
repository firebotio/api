require "rails_helper"

describe V1::ModelsController do
  include_context :authorize
  include_context :load_schema

  let(:attributes) { { first_name: "first_name" } }
  let(:model) do
    ModelCollection.new(
      name: controller.collection_name, type: object_type
    ).create attributes.merge({ object_type: object_type })
  end
  let(:object_type) { "Test" }
  let(:schema)      { Schema.new name: object_type }

  describe "POST create" do
    before { post :create, attributes.merge({ type: object_type }) }

    it "should return a hash with the attributes in it" do
      expect(json_response[:first_name]).to eq "first_name"
    end

    it "should create a Model" do
      expect(controller.collection_with_type.count).to eq 1
    end
  end

  describe "DELETE destroy" do
    before { delete :destroy, id: model.id.to_s, type: object_type }

    it "should destroy a Model" do
      expect(controller.collection_with_type.count).to eq 0
    end

    it "should render nothing" do
      expect(response.status).to eq 204
    end
  end
end
