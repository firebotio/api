class ParseObject
  attr_reader :schema

  def initialize(options = {})
    @object_type = options[:object_type]
    @schema      = options[:schema]
    Parse.init(
      api_key:        options[:access_token].parse_api_key,
      application_id: options[:access_token].parse_application_id
    )
  end

  def assign_attributes(object, attributes = {})
    attributes.keys.each_with_object(object) do |key, obj|
      symbol = key.to_sym
      type   = schema.schema[symbol][:type] if schema.keys.include?(symbol)
      value  = attributes[key]
      value  = schema.create_relationship(symbol, value) if type == "relation"
      object[key] = value
    end
  end

  def new_object(attributes = {})
    object = Parse::Object.new @object_type
    assign_attributes object, attributes
  end
end
