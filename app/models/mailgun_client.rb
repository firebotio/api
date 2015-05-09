class MailgunClient
  def initialize(options = {})
    @from    = options[:from]
    @subject = options[:subject]
    @text    = options[:text]
    @to      = options[:to]
  end

  def send_message
    client.send_message ENV["MAILGUN_DOMAIN"], payload
  end

  private

  def client
    @client ||= Mailgun::Client.new(ENV["MAILGUN_API_KEY"])
  end

  def payload
    {
      from:    @from,
      subject: @subject,
      text:    @text,
      to:      @to
    }
  end
end
