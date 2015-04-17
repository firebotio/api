class ParseQuery < ParseClient
  def find_object(id)
    objects = query.tap do |q|
      q.eq "objectId", id
      q.limit = 1
    end
    objects.get.first
  end

  def search(params = {})
    objects = query.tap do |q|
      params.each do |key, value|
        key_symbol = key.to_sym
        if schema.keys.include? key_symbol
          q.eq key, sanitize_value(value, schema.schema[key_symbol][:type], key)
        end
      end
    end
    objects.get
  end

  private

  def query
    unless @query
      initialize_parse
      @query = Parse::Query.new @object_type
    end
    @query
  end

  def sanitize_value(value, type, key)
    case type
    when "number"
      if value.match /\.{1}/
        value.to_f
      else
        value.to_i
      end
    when "relation"
      schema.create_relationship key.to_sym, value
    end
  end
end
