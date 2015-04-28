require "rails_helper"

describe ApplicationController do
  controller do
    include Schemable

    def index
      render nothing: true
    end
  end

  describe "#load_schema" do
    controller do
      before_action :load_schema
    end

    before { get :index }

    context "when schema does not exist" do
      controller do
        class FakeSchema
          def exists?
            false
          end
        end

        def schema
          FakeSchema.new
        end
      end

      it "should render json with errors" do
        expect(json_response[:errors]).to have_key :schema
      end
    end
  end

  describe "#schema" do
    include_context :authorize

    it "should return a Schema" do
      expect(controller.schema.class).to eq Schema
    end
  end

  describe "#validate_model" do
    controller do
      before_action :validate_model
    end

    include_context :authorize
    include_context :load_schema

    before { get :index, skills: 1 }

    context "when validator is not valid" do
      it "should render json with errors" do
        expect(json_response[:errors]).to be_present
      end
    end
  end
end
