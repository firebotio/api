require "rails_helper"

describe AccessToken do
  let(:application_id) { SecureRandom.uuid }
  let(:expires_at)     { Time.now + 1.year }
  let(:parse_api_key)        { SecureRandom.uuid }
  let(:parse_application_id) { SecureRandom.uuid }
  let(:token)          { SecureRandom.uuid }
  let(:tokenable_id)   { 1 }
  let(:tokenable_type) { "BackendApp" }
  let(:tokenable_uid)  { application_id }

  subject { described_class.new application_id: application_id, token: token }

  before do
    allow(subject).to receive(:find_by_token).with(token).and_return(
      {
        "expires_at" => expires_at,
        "metadata" => {
          "api_key"        => parse_api_key,
          "application_id" => parse_application_id
        }.to_json,
        "tokenable_id"   => tokenable_id,
        "tokenable_type" => tokenable_type,
        "tokenable_uid"  => tokenable_uid
      }
    )
  end

  describe "#parse_api_key" do
    it "should return the api key from the metadata" do
      expect(subject.parse_api_key).to eq parse_api_key
    end
  end

  describe "#parse_application_id" do
    it "should return the application id from the metadata" do
      expect(subject.parse_application_id).to eq parse_application_id
    end
  end

  describe "#error" do
    context "when expires_at is nil" do
      let(:expires_at) { nil }

      it "should return invalid or missing" do
        expect(subject.error).to eq "invalid or missing"
      end
    end

    context "when application_id is not equal to tokenable_uid" do
      let(:tokenable_uid) { SecureRandom.uuid }

      it "should return invalid application id" do
        expect(subject.error).to eq "invalid application id"
      end
    end

    context "when expired" do
      let(:expires_at) { Time.now - 1.year }

      it "should return expired" do
        expect(subject.error).to eq "expired"
      end
    end
  end

  describe "#tokenable_id" do
    it "should equal the access_token's tokenable_id" do
      expect(subject.tokenable_id).to eq tokenable_id
    end
  end

  describe "#tokenable_type" do
    it "should equal the access_token's tokenable_type" do
      expect(subject.tokenable_type).to eq tokenable_type
    end
  end

  describe "valid?" do
    context "when everything is valid" do
      it "should return true" do
        expect(subject.valid?).to be true
      end
    end

    context "when expires_at is nil" do
      let(:expires_at) { nil }

      it "should return false" do
        expect(subject.valid?).to be false
      end
    end

    context "when tokenable_id is nil" do
      let(:tokenable_id) { nil }

      it "should return false" do
        expect(subject.valid?).to be false
      end
    end

    context "when tokenable_type is nil" do
      let(:tokenable_type) { nil }

      it "should return false" do
        expect(subject.valid?).to be false
      end
    end

    context "when valid_application_id is false" do
      let(:tokenable_uid) { SecureRandom.uuid }

      it "should return false" do
        expect(subject.valid?).to be false
      end
    end

    context "when expired" do
      let(:expires_at) { Time.now - 1.year }

      it "should return false" do
        expect(subject.valid?).to be false
      end
    end
  end

  # private

  describe "#find_by_token" do
    let(:access_token) { described_class.new }

    it "should receive :find_by_token" do
      begin
        access_token.send :find_by_token, nil
      rescue
      end
    end
  end
end
