class AccessToken
  attr_reader :expires_at, :tokenable_id, :tokenable_type

  def initialize(options = {})
    result = find_by_token options[:application_key]
    if result
      @application_id = options[:application_id]
      @expires_at     = result["expires_at"].try :to_datetime
      @metadata       = JSON.parse result["metadata"], symbolize_names: true
      @tokenable_id   = result["tokenable_id"]
      @tokenable_type = result["tokenable_type"]
      @tokenable_uid  = result["tokenable_uid"]
    end
  end

  def api_key
    @metadata[:api_key]
  end

  def application_id
    @metadata[:application_id]
  end

  def error
    if expires_at.nil? || tokenable_id.nil? || tokenable_type.nil?
      "invalid or missing"
    elsif !valid_application_id
      "invalid application id"
    elsif expired?
      "expired"
    end
  end

  def valid?
    expires_at && tokenable_id && tokenable_type &&
    valid_application_id && !expired?
  end

  private

  def expired?
    expires_at < Time.now
  end

  def fields
    "expires_at, metadata, tokenable_id, tokenable_type, tokenable_uid"
  end

  def find_by_token(token)
    ActiveRecord::Base.connection.exec_query(
      "SELECT #{fields} FROM Tokens WHERE token = '#{token}' LIMIT 1;"
    ).first
  end

  def valid_application_id
    @application_id == @tokenable_uid
  end
end
