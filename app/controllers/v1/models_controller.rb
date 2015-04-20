class V1::ModelsController < ApplicationController
  include Collectable
  include Schemable
  include Sessionable

  before_action :authorize
  before_action :load_schema,    except: %i(destroy)
  before_action :find_model,     only: %i(destroy show update)
  before_action :validate_model, only: %i(create update)

  def create
    model = collection.create permitted
    render json: model,
           serializer: model_serializer,
           location: show_v1_models_url(id: model.id, host: ENV["HOST"])
  end

  def destroy
    model_with_collection.destroy
    render nothing: true, status: :no_content
  end

  def index
    render json: collection_with_type,
           each_serializer: model_serializer,
           root: :objects,
           meta: { total: 10, info: "revisit" }
  end

  def show
    render json: @model, serializer: model_serializer
  end

  def update
    model_with_collection.update_attributes permitted
    render json: @model, serializer: model_serializer
  end

  private

  def find_model
    @model = collection_with_type.find_by id: params[:id]
    not_found if @model.nil?
  end

  def model_serializer
    if @model_serializer.nil?
      @model_serializer        = ModelSerializer
      @model_serializer.schema = schema
    end
    @model_serializer
  end

  def model_with_collection
    @model.with_collection collection_name
  end
end
