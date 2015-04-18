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
  let(:relationship_to) { "User" }
  let(:schema)          { Schema.new }

  subject { described_class.new attributes }

  before do
    allow(schema).to receive(:model).and_return(
      {
        "schema" => {
          age: {
            type: "number"
          },
          first_name: {
            type: "string"
          },
          last_name: {
            type: "string"
          },
          user: {
            relationship_to: relationship_to,
            type: "relation"
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
    let(:where) do
      {
        "age" => 20,
        "first_name" => "first_name",
        "last_name" => "last_name",
        "user" => {
          "object_id" => "123",
          "object_type" => relationship_to
        }
      }
    end
    let(:url) { [endpoint, "where=#{CGI.escape where.to_json}"].join "?" }

    before do
      stub_request(:get, url).to_return body: body
    end

    context "when schema includes the key" do
      it "should receive :sanitize_value" do
        expect(subject).to receive(:sanitize_value).exactly(4).times
        .and_call_original

        subject.search where.merge({ "age" => "20", "user" => "123" })
      end
    end

    context "when schema does not include key" do
      let(:where) { {} }

      it "should not receive :sanitize_value" do
        expect(subject).not_to receive :sanitize_value

        subject.search({ "email" => "email" })
      end
    end
  end
end
