class Session
  HEADER = "Firebot-Authorization"

  def initialize(request)
    @request = request
  end

  def access_token
    @access_token ||= AccessToken.new(token)
  end

  private

  def token
    @request.headers[HEADER]
  end
end
