require "rails_helper"

describe ObjectPaginator do
  subject { described_class.new collection: [], params: {} }

  describe "#json" do
    it "should have key json" do
      expect(subject.json).to have_key :json
    end

    it "should have key meta" do
      expect(subject.json).to have_key :meta
    end

    it "should have key each_serializer" do
      expect(subject.json).to have_key :each_serializer
    end

    it "should receive message :objects" do
      expect(subject).to receive(:objects).exactly(2).times
      subject.json
    end

    it "should receive message :metadata" do
      expect(subject).to receive :metadata
      subject.json
    end
  end
end
