class V1::ObjectsController < ApplicationController
  include Schemable

  before_action :configure_parse
  before_action :load_schema
  before_action :find_object,    only: %i(destroy show update)
  before_action :validate_model, only: %i(create update)

  def create
    object = Parse::Object.new object_type
    assign_attributes object
    render json: object.save, serializer: parse_object_serializer
  end

  def destroy
    @object.parse_delete
    render nothing: true, status: :no_content
  end

  def index
    objects =
      Kaminari.paginate_array(query.get).page(current_page).per(per_page)
    render json: objects,
           each_serializer: parse_object_serializer,
           meta: metadata(objects.total_pages)
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
      object[key] = value
    end
  end

  def configure_parse
    Parse.init(
      application_id: access_token.application_id,
      api_key:        access_token.api_key
    )
  end

  def current_page
    params[:page] ? params[:page].to_i : 1
  end

  def find_object
    objects = query.tap do |q|
      q.eq "objectId", params[:id]
      q.limit = 1
    end
    @object = objects.get.first
    not_found unless @object
  end

  def metadata(total_pages)
    {
      per_page:     per_page,
      current_page: current_page,
      total_pages:  total_pages,
      links: {
        previous_page: previous_page,
        next_page:     next_page(total_pages)
      }
    }
  end

  def next_page(total_pages)
    if current_page < total_pages
      v1_objects_path page: current_page + 1, type: object_type
    end
  end

  def parse_object_serializer
    if @parse_object_serializer.nil?
      @parse_object_serializer        = ParseObjectSerializer
      @parse_object_serializer.schema = schema
    end
    @parse_object_serializer
  end

  def per_page
    params[:per_page] ? params[:per_page] : 10
  end

  def previous_page
    if current_page > 1
      v1_objects_path page: current_page - 1, type: object_type
    end
  end

  def query
    @query ||= Parse::Query.new(object_type)
  end
end
