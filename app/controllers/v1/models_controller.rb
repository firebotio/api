class V1::ModelsController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json

  # before_action :set_access_control_headers

  def index
    render json: collection,
           each_serializer: model_serializer,
           meta: { total: 10 },
           root: :objects
  end

  def show
    render json: collection.find_by(id: params[:id]),
           serializer: model_serializer
  end

  private

  def collection
    Model.with(collection: collection_name).where type: params[:type]
  end

  def collection_name
    params[:collection]
  end

  def model_serializer
    if @model_serializer.nil?
      @model_serializer = ModelSerializer
      @model_serializer.schema = schema
    end
    @model_serializer
  end

  def schema
    %i(id name type created_at updated_at wtf)
  end

  def set_access_control_headers
    headers["Access-Control-Allow-Headers"] =
      %w(Accept Authorization Content-Type Origin X-Requested-With).join(",")
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] =
      %w(DELETE GET OPTIONS PATCH POST PUT).join(",")
    headers["Access-Control-Request-Method"] = "*"
  end
end
