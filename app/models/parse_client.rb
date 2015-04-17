class ParseClient
  attr_reader :schema

  def initialize(options = {})
    @access_token = options[:access_token]
    @object_type  = options[:object_type]
    @schema       = options[:schema]
  end

  private

  def initialize_parse
    Parse.init(
      api_key:        @access_token.parse_api_key,
      application_id: @access_token.parse_application_id
    )
  end
end
