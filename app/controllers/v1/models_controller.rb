class V1::ModelsController < ApplicationController
  before_action :find_model, only: %i(destroy show update)

  def create
    render json: collection.create!(permitted), serializer: model_serializer
  end

  def destroy
    model_with_collection.destroy
    render nothing: true, status: :no_content
  end

  def index
    render json: collection_type,
           each_serializer: model_serializer,
           root: :objects,
           meta: { total: 10 }
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
    Model.with collection: collection_name
  end

  def collection_type
    collection.where object_type: object_type
  end

  def collection_name
    "#{access_token.tokenable_type}-#{backend_app_id}"
  end

  def find_model
    @model = collection_type.find_by id: params[:id]
    not_found if @model.nil?
  end

  def model_with_collection
    @model.with collection: collection_name
  end

  def model_serializer
    if @model_serializer.nil?
      @model_serializer        = ModelSerializer
      @model_serializer.schema = schema_keys
    end
    @model_serializer
  end

  def object_type
    params[:type]
  end

  def permitted
    params.keys.each_with_object({ object_type: object_type }) do |key, hash|
      hash[key] = params[key] if schema.attributed_permitted?(key)
    end
  end

  def schema
    @schema ||= Schema.new(backend_app_id: backend_app_id, name: object_type)
  end

  def schema_keys
    schema.keys
  end
end
