require "rails_helper"

describe V1::ModelsController do
  include_context :authorize
  include_context :load_schema

  let(:attributes) { { first_name: "first_name" } }
  let(:model) do
    model_collection.create attributes.merge({ object_type: object_type })
  end
  let(:model_collection) do
    ModelCollection.new name: controller.collection_name, type: object_type
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

  describe "GET index" do
    before do
      model
      get :index, type: object_type
    end

    it "should return array with model" do
      expect(json_response[:objects].first[:id]).to eq model.id.to_s
    end
  end

  describe "GET show" do
    before { get :show, id: model.id.to_s, type: object_type }

    it "should return json with model" do
      expect(json_response[:id]).to eq model.id.to_s
    end
  end

  describe "PATCH/PUT update" do
    let(:action) do
      patch :update, id: model.id.to_s, type: object_type,
                     first_name: first_name
    end
    let(:first_name) { "new_first_name" }

    before { action }

    context "when method is PATCH" do
      it "should update the model" do
        m = model_collection.with_type.find_by id: model.id.to_s
        expect(m.first_name).to eq first_name
      end
    end

    context "when method is PUT" do
      let(:action) do
        put :update, id: model.id.to_s, type: object_type,
                       first_name: first_name
      end

      it "should update the model" do
        m = model_collection.with_type.find_by id: model.id.to_s
        expect(m.first_name).to eq first_name
      end
    end
  end
end
