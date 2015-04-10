require "rails_helper"

describe AccessToken do
  let(:columns) { "expires_at, token, tokenable_id, tokenable_type, user_id" }
  let(:expires_at)     { Time.now + 1.year }
  let(:token)          { SecureRandom.uuid }
  let(:tokenable_id)   { 1 }
  let(:tokenable_type) { "BackendApp" }
  let(:user_id)        { 1 }
  let(:values) do
    "'#{expires_at}', '#{token}', '#{tokenable_id}', '#{tokenable_type}', " \
    "'#{user_id}'"
  end

  subject { described_class.new token }

  before do
    connection = ActiveRecord::Base.connection
    create_columns = [
      "expires_at date", "token varchar(255)", "tokenable_id integer",
      "tokenable_type varchar(255)", "user_id integer"
    ].join(", ")
    connection.exec_query(
      "CREATE TABLE Tokens (#{create_columns});"
    )
    connection.exec_query(
      "INSERT INTO Tokens (#{columns}) VALUES (#{values});"
    )
  end

  describe "#error" do
    context "when expires_at, tokenable_id, and tokenable_type not nil" do
      it "should return nil" do
        expect(subject.error).to be_nil
      end
    end

    context "when expires_at, tokenable_id, or tokenable_type nil" do
      let(:columns) { "token, user_id" }
      let(:values)  { "'#{token}', '#{user_id}'" }

      it "should return an error" do
        expect(subject.error).to eq "invalid or missing"
      end
    end

    context "when expires_at is in the past" do
      let(:expires_at) { Time.now - 1.year }

      it "should return an error" do
        expect(subject.error).to eq "expired"
      end
    end
  end
end
