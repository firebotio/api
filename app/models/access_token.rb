class AccessToken
  def initialize(options = {})
    @application_id = options[:application_id]
    @token          = options[:token]
  end

  def parse_api_key
    metadata[:api_key]
  end

  def parse_application_id
    metadata[:application_id]
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

  def tokenable_id
    @tokenable_id ||= access_token["tokenable_id"]
  end

  def tokenable_type
    @tokenable_type ||= access_token["tokenable_type"]
  end

  def valid?
    expires_at.present? && tokenable_id.present? && tokenable_type.present? &&
    valid_application_id && !expired?
  end

  private

  def access_token
    @access_token ||= find_by_token(@token)
  end

  def expired?
    expires_at < Time.now
  end

  def expires_at
    @expires_at ||= access_token["expires_at"].try(:to_datetime)
  end

  def find_by_token(token)
    fields = "expires_at, metadata, tokenable_id, tokenable_type, tokenable_uid"
    ActiveRecord::Base.connection.exec_query(
      "SELECT #{fields} FROM Tokens WHERE token = '#{token}' LIMIT 1;"
    ).first
  end

  def metadata
    @metadata ||= JSON.parse(access_token["metadata"], symbolize_names: true)
  end

  def tokenable_uid
    @tokenable_uid ||= access_token["tokenable_uid"]
  end

  def valid_application_id
    @application_id == tokenable_uid
  end
end
