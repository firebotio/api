class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  respond_to :json

  before_action :authorize

  private

  def access_token
    @access_token ||= ActiveRecord::Base.connection.exec_query(
        "SELECT * FROM Tokens WHERE token = '#{token}' LIMIT 1;"
      ).first
  end

  def authorize
    error = nil
    if access_token.nil?
      error = "invalid or missing"
    elsif access_token["expires_at"].to_datetime < Time.now
      error = "expired"
    end
    render json: { errors: { token: error } } if error
  end

  def set_access_control_headers
    headers["Access-Control-Allow-Headers"] =
      %w(Accept Authorization Content-Type Origin X-Requested-With).join(",")
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] =
      %w(DELETE GET OPTIONS PATCH POST PUT).join(",")
    headers["Access-Control-Request-Method"] = "*"
  end

  def token
    request.headers["Firebot-Authorization"]
  end
end
