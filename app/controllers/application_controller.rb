class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  respond_to :json

  before_action :authorize

  private

  def access_token
    @access_token ||= session.access_token
  end

  def authorize
    unless access_token.valid?
      render json: { errors: { token: access_token.error } }
    end
  end

  def not_found
    render nothing: true, status: :not_found
  end

  def session
    @session ||= Session.new(request)
  end

  def set_access_control_headers
    headers["Access-Control-Allow-Headers"] =
      %w(Accept Authorization Content-Type Origin X-Requested-With).join(",")
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] =
      %w(DELETE GET OPTIONS PATCH POST PUT).join(",")
    headers["Access-Control-Request-Method"] = "*"
  end
end
