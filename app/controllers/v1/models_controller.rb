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

  def collection
    Model.with collection: collection_name
  end

  def collection_type
    collection.where object_type: params[:type]
  end

  def collection_name
    "#{access_token["tokenable_type"]}-#{access_token["tokenable_id"]}"
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
      @model_serializer.schema = schema
    end
    @model_serializer
  end

  def not_found
    render nothing: true, status: :not_found
  end

  def permitted
    allowed = schema - %i(created_at id object_type updated_at)
    params.keys.each_with_object({ object_type: params[:type] }) do |key, hash|
      hash[key] = params[key] if allowed.index(key.to_sym)
    end
  end

  def schema
    %i(id name object_type created_at updated_at)
  end
end
