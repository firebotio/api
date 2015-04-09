class AccessToken
  attr_reader :expires_at, :tokenable_id, :tokenable_type

  def initialize(token)
    result = find_by_token token
    if result
      @expires_at     = result["expires_at"].to_datetime
      @tokenable_id   = result["tokenable_id"]
      @tokenable_type = result["tokenable_type"]
    end
  end

  def error
    if expires_at.nil? || tokenable_id.nil? || tokenable_type.nil?
      "invalid or missing"
    elsif expired?
      "expired"
    end
  end

  def valid?
    expires_at && tokenable_id && tokenable_type && !expired?
  end

  private

  def expired?
    expires_at < Time.now
  end

  def fields
    "expires_at, tokenable_id, tokenable_type"
  end

  def find_by_token(token)
    ActiveRecord::Base.connection.exec_query(
      "SELECT #{fields} FROM Tokens WHERE token = '#{token}' LIMIT 1;"
    ).first
  end
end
