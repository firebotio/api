class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  respond_to :json

  private

  def not_found
    render nothing: true, status: :not_found
  end
end
