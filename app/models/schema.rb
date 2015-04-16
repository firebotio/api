class Schema
  def initialize(options = {})
    @backend_app_id = options[:backend_app_id]
    @name           = options[:name]
  end

  def create_relationship(key, value)
    {
      object_id:   value,
      object_type: schema[key][:relationship_to]
    }
  end

  def exists?
    model_schema.present?
  end

  def keys
    schema.keys.map(&:to_sym)
  end

  def permitted_params(params)
    params.keys.each_with_object({ object_type: @name }) do |key, hash|
      hash[key] = params[key] if attributed_permitted?(key)
    end
  end

  def schema
    @schema ||= JSON.parse(model_schema, symbolize_names: true)
  end

  private

  def attributed_permitted?(attribute)
    permitted_attributes.index attribute.to_sym
  end

  def ignored_attributes
    %i(created_at id object_type updated_at)
  end

  def model
    @model ||= ActiveRecord::Base.connection.exec_query(
      "SELECT * FROM Models WHERE (#{query}) LIMIT 1;"
    ).first
  end

  def model_schema
    @model_schema ||= model.try(:fetch, "schema")
  end

  def permitted_attributes
    keys - ignored_attributes
  end

  def query
    "backend_app_id = '#{@backend_app_id}' AND name = '#{@name}'"
  end
end
