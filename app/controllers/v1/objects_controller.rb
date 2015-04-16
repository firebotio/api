class V1::ObjectsController < ApplicationController
  include Schemable

  before_action :load_schema
  before_action :find_object,    only: %i(destroy show update)
  before_action :validate_model, only: %i(create update)

  def create
    object = query.new_object
    assign_attributes object
    render json: object.save, serializer: parse_object_serializer
  end

  def destroy
    @object.parse_delete
    render nothing: true, status: :no_content
  end

  def index
    render paginator.json(parse_object_serializer)
  end

  def show
    render json: @object, serializer: parse_object_serializer
  end

  def update
    assign_attributes @object
    render json: @object.save, serializer: parse_object_serializer
  end

  private

  def assign_attributes(object)
    permitted.each do |key, value|
      type = ""
      type = schema.schema[key.to_sym][:type] if schema.keys.include? key.to_sym
      if type == "relation"
        value = schema.create_relationship key.to_sym, value
      end
      object[key] = value
    end
  end

  def find_object
    @object = query.find_object params[:id]
    not_found unless @object
  end

  def parse_object_serializer
    if @parse_object_serializer.nil?
      @parse_object_serializer        = ParseObjectSerializer
      @parse_object_serializer.schema = schema
    end
    @parse_object_serializer
  end

  def paginator
    @paginator ||= ObjectPaginator.new(
      collection: query.search(params), params: params
    )
  end

  def query
    @query ||= ParseQuery.new(
      access_token: access_token, object_type: object_type, schema: schema
    )
  end
end
