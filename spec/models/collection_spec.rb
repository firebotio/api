require "rails_helper"

describe Collection do
  let(:model) { Model }
  let(:name)  { "Test" }
  let(:type)  { "Car" }

  subject { described_class.new model: model, name: name, type: type }

  it { should respond_to :create }

  describe "#with_type" do
    it "should send where to query" do
      expect(model).to receive(:where).with({ object_type: type })
      subject.with_type
    end
  end
end
