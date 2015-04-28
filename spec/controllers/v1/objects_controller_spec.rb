require "rails_helper"

describe V1::ObjectsController do
  include_context :authorize
  include_context :load_schema

  let(:body) do
    { "results" => [{ first_name: "first_name", id: object_id }] }.to_json
  end
  let(:endpoint) { "https://api.parse.com/1/classes/#{object_type}" }
  let(:object_id)   { "1" }
  let(:object_type) { "Test" }
  let(:permitted) do
    {
      "first_name" => "first_name"
    }
  end
  let(:where)  { { "objectId" => object_id }.to_json }
  let(:url) do
    [endpoint, ["limit=1", "where=#{CGI.escape where}"].join("&")].join "?"
  end

  describe "POST create" do
    before do
      stub_request(:post, endpoint)
      .and_return(body: { "first_name" => "first_name"}.to_json)

      post :create, type: object_type
    end

    it "should return json with correct key and value" do
      expect(JSON.parse(response.body)["first_name"]).to eq "first_name"
    end
  end

  describe "DELETE destroy" do
    before do
      stub_request(:get, url).and_return body: body
      delete :destroy, id: object_id, type: object_type
    end

    it "should render nothing" do
      expect(response.status).to eq 204
    end
  end

  describe "GET index" do
    let(:url) { [endpoint, "where=#{CGI.escape({}.to_json)}"].join "?" }

    before do
      stub_request(:get, url).and_return body: body
      get :index, type: object_type
    end

    it "should render json with objects" do
      expect(JSON.parse response.body).to have_key "objects"
    end
  end

  describe "GET show" do
    before do
      stub_request(:get, url).and_return body: body
      get :show, id: object_id, type: object_type
    end

    it "should return a hash" do
      expect(JSON.parse response.body).to have_key "first_name"
    end
  end

  describe "PATCH/PUT update" do
    let(:action) do
      patch :update, id: object_id, type: object_type, first_name: "first_name"
    end

    before do
      stub_request(:get, url).and_return body: body
      stub_request(:post, endpoint).and_return body: body
      action
    end

    context "when action is patch" do
      it "should update object" do
        expect(JSON.parse response.body).to have_key "first_name"
      end
    end

    context "when action is put" do
      let(:action) do
        put :update, id: object_id, type: object_type, first_name: "first_name"
      end

      it "should update object" do
        expect(JSON.parse response.body).to have_key "first_name"
      end
    end
  end
end
