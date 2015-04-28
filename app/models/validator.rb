class Validator
  def initialize(options = {})
    @params = options[:params]
    @schema = options[:schema]
  end

  def errors
    @errors ||= {}
  end

  def valid?
    @schema.schema.each do |key, value|
      column = @params[key.to_s]
      validate_type(key, value[:type], column) if column
      validate_required key, value[:required], column
    end
    errors.empty?
  end

  private

  def validate_required(key, required, column)
    errors[key] = "is required" if required && column.nil?
  end

  def validate_array(key, column)
    errors[key] = "is not an array" if column.class != [].class
  end

  def validate_boolean(key, column)
    unless [true.class, false.class].include? column.class
      errors[key] = "is not a boolean"
    end
  end

  def validate_coordinate(key, column)
    # TODO
  end

  def validate_date(key, column)
    begin
      column.to_datetime
    rescue ArgumentError
      errors[key] = "is not a date"
    end
  end

  def validate_file(key, column)
    # TODO
  end

  def validate_number(key, column)
    unless [1.class, 1.0.class].include? column.class
      errors[key] = "is not a number"
    end
  end

  def validate_object(key, column)
    # TODO
  end

  def validate_pointer(key, column)
    # TODO
  end

  def validate_relation(key, column)
    # TODO
  end

  def validate_string(key, column)
    errors[key] = "is not a string" if column.class != "".class
  end

  def validate_type(key, type, column)
    validate_array(key, column) if type == "array"
    validate_boolean(key, column) if type == "boolean"
    validate_coordinate(key, column) if type == "coordinate"
    validate_date(key, column) if type == "date"
    validate_file(key, column) if type == "file"
    validate_number(key, column) if type == "number"
    validate_object(key, column) if type == "object"
    validate_pointer(key, column) if type == "pointer"
    validate_relation(key, column) if type == "relation"
    validate_string(key, column) if type == "string"
  end
end
