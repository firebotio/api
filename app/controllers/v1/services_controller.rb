class V1::ServicesController < ApplicationController
  include Sessionable

  before_action :authorize, only: %i(email)

  protect_from_forgery with: :null_session

  def email
    result = mailgun_client.send_message
    render json: result.body, status: 200
  end

  # def sms
  #   puts params
  #   render nothing: true, status: 200
  # end

  private

  def mailgun_client
    @mailgun_client ||= MailgunClient.new(params)
  end
end
