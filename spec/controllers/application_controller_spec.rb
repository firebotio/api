require "rails_helper"

describe ApplicationController do
  controller do
    def index
      not_found
    end
  end

  describe "#not_found" do
    before { get :index }

    it "should render nothing" do
      expect(response).to render_template nil
    end

    it "should return status 404" do
      expect(response.status).to eq 404
    end
  end
end
