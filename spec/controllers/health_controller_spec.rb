require "rails_helper"

describe HealthController do
  describe "GET index" do
    subject { get :index }

    it "should render nothing" do
      expect(subject.body).to be_blank
    end

    it "should have a status 200" do
      expect(subject.status).to eq 200
    end
  end
end
