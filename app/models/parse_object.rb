class ParseObject < ParseClient
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
    assign_attributes object, attributes
  end

  private

  def object
    unless @object
      initialize_parse
      @object = Parse::Object.new @object_type
    end
    @object
  end
end
