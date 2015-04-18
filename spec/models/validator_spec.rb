require "rails_helper"

describe Validator do
  let(:params) { {} }
  let(:schema) do
    double "schema", schema: {
      age: {
        required: false,
        type: "number"
      },
      dob: {
        required: false,
        type: "date"
      },
      first_name: {
        required: true,
        type: "string"
      },
      injured: {
        required: false,
        type: "boolean"
      },
      weapons: {
        required: false,
        type: "array"
      }
    }
  end

  subject { described_class.new params: params, schema: schema }

  describe "#errors" do
    it "should return a hash" do
      expect(subject.errors.class).to eq Hash
    end
  end

  describe "#valid?" do
    context "when all params meet requird and type validations" do
      let(:params) { { "first_name" => "first_name" } }

      it "should return true" do
        expect(subject.valid?).to be true
      end
    end

    context "when a required field is missing" do
      it "should return false" do
        expect(subject.valid?).to be false
      end

      it "should have the correct key in the errors" do
        subject.valid?
        expect(subject.errors).to have_key :first_name
      end
    end

    context "when there is an incorrect type of array" do
      let(:params) { { "weapons" => "sword" } }

      it "should return false" do
        expect(subject.valid?).to be false
      end

      it "should have the correct key in the errors" do
        subject.valid?
        expect(subject.errors).to have_key :weapons
      end
    end

    context "when there is an incorrect type of boolean" do
      let(:params) { { "injured" => "no" } }

      it "should return false" do
        expect(subject.valid?).to be false
      end

      it "should have the correct key in the errors" do
        subject.valid?
        expect(subject.errors).to have_key :injured
      end
    end

    context "when there is an incorrect type of date" do
      let(:params) { { "dob" => "today" } }

      it "should return false" do
        expect(subject.valid?).to be false
      end

      it "should have the correct key in the errors" do
        subject.valid?
        expect(subject.errors).to have_key :dob
      end
    end

    context "when there is an incorrect type of number" do
      let(:params) { { "age" => "five" } }

      it "should return false" do
        expect(subject.valid?).to be false
      end

      it "should have the correct key in the errors" do
        subject.valid?
        expect(subject.errors).to have_key :age
      end
    end

    context "when there is an incorrect type of string" do
      let(:params) { { "first_name" => 1 } }

      it "should return false" do
        expect(subject.valid?).to be false
      end

      it "should have the correct key in the errors" do
        subject.valid?
        expect(subject.errors).to have_key :first_name
      end
    end
  end
end
