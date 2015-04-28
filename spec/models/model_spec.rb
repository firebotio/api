require "rails_helper"

describe Model do
  subject { build :model }

  it { should have_fields(:object_type).of_type String }

  it { should validate_presence_of :object_type }

  describe "#with_collection" do
    let(:name) { "name" }

    it "should receive with message with collection and name" do
      expect(subject).to receive(:with).with({ collection: name })
      subject.with_collection name
    end
  end
end
