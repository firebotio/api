class V1::ModelsController < ApplicationController
  before_action :find_model,      only: %i(destroy show update)
  before_action :validate_schema, except: %i(destroy)

  def create
    render json: collection.create(permitted), serializer: model_serializer
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

  def backend_app_id
    access_token.tokenable_id
  end

  def collection
    @collection ||= ModelCollection.new(
      name: collection_name, type: object_type
    )
  end

  def collection_with_type
    collection.with_type
  end

  def collection_name
    "#{access_token.tokenable_type}-#{backend_app_id}"
  end

  def find_model
    @model = collection_with_type.find_by id: params[:id]
    not_found if @model.nil?
  end

  def model_with_collection
    @model.with_collection collection_name
  end

  def model_serializer
    if @model_serializer.nil?
      @model_serializer        = ModelSerializer
      @model_serializer.schema = schema
    end
    @model_serializer
  end

  def object_type
    params[:type]
  end

  def permitted
    schema.permitted_params params
  end

  def schema
    @schema ||= Schema.new(backend_app_id: backend_app_id, name: object_type)
  end

  def validate_schema
    unless schema.valid?
      render json: { errors: { schema: "invalid for #{object_type} model" } }
    end
  end
end
