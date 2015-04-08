class V1::ModelsController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json

  # before_action :set_access_control_headers

  def index
    serializer = ModelSerializer
    serializer.schema = %i(id name type created_at updated_at wtf)
    render json: collection, each_serializer: serializer,
           meta: { total: 10 }, root: :objects
  end

  def show
    render json: collection.find_by(id: params[:id])
  end

  private

  def collection
    Model.with(collection: params[:collection]).where type: params[:type]
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
