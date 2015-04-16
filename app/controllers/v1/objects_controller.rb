class V1::ObjectsController < ApplicationController
  include Schemable

  before_action :load_schema
  before_action :find_object,    only: %i(destroy show update)
  before_action :validate_model, only: %i(create update)

  def create
    object = parse_object.new_object permitted
    render json: object.save, serializer: parse_object_serializer
  end

  def destroy
    @object.parse_delete
    render nothing: true, status: :no_content
  end

  def index
    render object_paginator.json(parse_object_serializer)
  end

  def show
    render json: @object, serializer: parse_object_serializer
  end

  def update
    object = parse_object.assign_attributes @object, permitted
    render json: object.save, serializer: parse_object_serializer
  end

  private

  def find_object
    @object = parse_query.find_object params[:id]
    not_found unless @object
  end

  def object_paginator
    @object_paginator ||= ObjectPaginator.new(
      collection: parse_query.search(params), params: params
    )
  end

  def parse_object_serializer
    if @parse_object_serializer.nil?
      @parse_object_serializer        = ParseObjectSerializer
      @parse_object_serializer.schema = schema
    end
    @parse_object_serializer
  end

  def parse_object
    @parse_object ||= ParseObject.new(parse_options)
  end

  def parse_options
    { access_token: access_token, object_type: object_type, schema: schema }
  end

  def parse_query
    @parse_query ||= ParseQuery.new(parse_options)
  end
end
