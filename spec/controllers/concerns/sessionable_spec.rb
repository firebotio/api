require "rails_helper"

describe ApplicationController do
  controller do
    include Sessionable

    def index
      render nothing: true
    end
  end

  before { get :index }

  describe "#access_token" do
    it "should return an AccessToken" do
      expect(controller.access_token.class).to eq AccessToken
    end
  end

  describe "#authorize" do
    class FakeAccessToken
      def error
        "error"
      end

      def valid?
        false
      end
    end

    controller do
      before_action :authorize

      def access_token
        FakeAccessToken.new
      end
    end

    it "should return json with errors" do
      expect(json_response[:errors]).to be_present
    end
  end

  describe "#session" do
    it "should return a Session" do
      expect(controller.session.class).to eq Session
    end
  end
end
