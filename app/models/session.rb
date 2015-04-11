class Session
  HEADER_APPLICATION_KEY = "X-Firebot-Application-Key"
  HEADER_APPLICATION_ID  = "X-Firebot-Application-Id"

  def initialize(request)
    @request = request
  end

  def access_token
    @access_token ||= AccessToken.new(
      application_key: application_key,
      application_id:  application_id
    )
  end

  private

  def application_key
    @request.headers[HEADER_APPLICATION_KEY]
  end

  def application_id
    @request.headers[HEADER_APPLICATION_ID]
  end
end
