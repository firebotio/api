class ParseObject < ParseClient
  def assign_attributes(object, attributes = {})
    attributes.keys.each_with_object(object) do |key, obj|
      value = attributes[key]
      if attribute_type(key) == "relation"
        value = schema.create_relationship key.to_sym, value
      end
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
