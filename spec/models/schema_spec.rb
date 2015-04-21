require "rails_helper"

describe Schema do
  let(:attributes) do
    {
      backend_app_id: backend_app_id,
      name:           name
    }
  end
  let(:backend_app_id)   { 1 }
  let(:name)             { "Test" }
  let(:relationship_key) { :user }
  let(:relationship_to)  { "User" }
  let(:schema_hash) do
    hash = {
      first_name: {
        type: "string"
      },
      last_name: {
        type: "string"
      }
    }
    hash[relationship_key] = {
      relationship_to: relationship_to,
      type: "relation"
    }
    hash
  end
  let(:schema_json) { { "schema" => schema_hash.to_json } }

  subject { described_class.new attributes }

  before { allow(subject).to receive(:model).and_return schema_json }

  describe "#create_relationship" do
    let(:relationship) do
      subject.create_relationship relationship_key, relationship_id
    end
    let(:relationship_id) { 5 }

    it "should have key object_id equal to value" do
      expect(relationship[:object_id]).to eq relationship_id
    end

    it "should have key object_type equal to the relationship_to" do
      expect(relationship[:object_type]).to eq relationship_to
    end
  end

  describe "#exists?" do
    context "when model_schema is present" do
      it "should return true" do
        expect(subject.exists?).to be true
      end
    end

    context "when model_schema is not present" do
      let(:schema_json) { { "schema" => nil } }

      it "should return false" do
        expect(subject.exists?).to be false
      end
    end
  end

  describe "#keys" do
    let(:keys) { subject.keys }

    it "should include all keys from the model schema" do
      expect(keys).to include :first_name
      expect(keys).to include :last_name
      expect(keys).to include relationship_key
    end
  end

  describe "#permitted_params" do
    let(:params) do
      {
        "first_name" => "first_name",
        "last_name"  => "last_name",
        "password"   => "password"
      }
    end
    let(:permitted_params) { subject.permitted_params params }

    it "should have only permitted params" do
      expect(permitted_params).to have_key "first_name"
      expect(permitted_params).to have_key "last_name"
    end

    it "should not have any unpermitted params" do
      expect(permitted_params).not_to have_key "password"
    end
  end

  describe "#schema" do
    let(:schema) { subject.schema }

    it "should have all the keys" do
      expect(schema).to have_key :first_name
      expect(schema).to have_key :last_name
      expect(schema).to have_key relationship_key
    end
  end

  # private

  describe "#model" do
    let(:schema) { described_class.new attributes }

    it "should receive :model" do
      begin
        schema.send :model
      rescue
      end
    end
  end
end
