require "rails_helper"

describe Session do
  let(:application_key_key) { "X-Firebot-Application-Key" }
  let(:application_id_key)  { "X-Firebot-Application-Id" }
  let(:headers) do
    {
      "#{application_key_key}" => "key",
      "#{application_id_key}"  => "id"
    }
  end
  let(:request) { double "request", headers: headers }

  subject { described_class.new request }

  it "should have the correct HEADER_APPLICATION_KEY" do
    expect(Session::HEADER_APPLICATION_KEY).to eq application_key_key
  end

  it "should have the correct HEADER_APPLICATION_ID" do
    expect(Session::HEADER_APPLICATION_ID).to eq application_id_key
  end

  describe "#access_token" do
    let(:access_token) { subject.access_token }

    it "should return an AccessToken" do
      expect(access_token.class).to be AccessToken
    end
  end
end
