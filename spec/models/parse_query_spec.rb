require "rails_helper"

describe ParseQuery do
  let(:access_token) do
    double "access_token", parse_api_key: "1", parse_application_id: "2"
  end
  let(:attributes) do
    {
      access_token: access_token,
      object_type:  object_type,
      schema:       schema
    }
  end
  let(:body)        { { "results" => [{ first_name: "first_name" }] }.to_json }
  let(:endpoint)    { "https://api.parse.com/1/classes/#{object_type}" }
  let(:object_type) { "Test" }
  let(:schema)      { Schema.new }

  subject { described_class.new attributes }

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

  describe "#find_object" do
    let(:object_id) { 1 }
    let(:where)     { { "objectId" => object_id }.to_json }
    let(:url) do
      [endpoint, ["limit=1", "where=#{CGI.escape where}"].join("&")].join "?"
    end

    before do
      stub_request(:get, url)
      .to_return body: body
    end

    it "should return a parse object" do
      expect(subject.find_object(object_id)).not_to be_nil
    end
  end

  describe "#search" do
    let(:where) { { "first_name" => "first_name" }.to_json }
    let(:url)   { [endpoint, "where=#{CGI.escape where}"].join "?" }

    before do
      stub_request(:get, url).to_return body: body
    end

    context "when schema includes the key" do
      it "should receive :sanitize_value" do
        expect(subject).to receive(:sanitize_value)
        .with("first_name", "string", "first_name")
        .and_call_original

        subject.search({ "first_name" => "first_name" })
      end
    end

    context "when schema does not include key" do
      let(:where) { {}.to_json }

      it "should not receive :sanitize_value" do
        expect(subject).not_to receive :sanitize_value

        subject.search({ "email" => "email" })
      end
    end
  end
end
