require "rails_helper"

describe ModelCollection do
  subject { described_class.new }

  it "should have Model as the model" do
    expect(subject.instance_variable_get("@model")).to eq Model
  end
end
