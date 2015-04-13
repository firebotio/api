module Sessionable
  extend ActiveSupport::Concern

  def access_token
    @access_token ||= session.access_token
  end

  def authorize
    unless access_token.valid?
      render json: { errors: { token: access_token.error } }
    end
  end

  def session
    @session ||= Session.new(request)
  end
end
