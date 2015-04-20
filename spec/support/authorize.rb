shared_context :authorize do
  let(:access_token) { controller.session.access_token }
  let(:application_id) { SecureRandom.uuid }
  let(:headers) do
    {
      "X-Firebot-Application-Key" => token,
      "X-Firebot-Application-Id"  => application_id
    }
  end
  let(:expires_at)     { Time.now + 1.year }
  let(:parse_api_key)        { SecureRandom.uuid }
  let(:parse_application_id) { SecureRandom.uuid }
  let(:token)          { SecureRandom.uuid }
  let(:tokenable_id)   { 1 }
  let(:tokenable_type) { "BackendApp" }
  let(:tokenable_uid)  { application_id }

  before do
    headers.each do |key, value|
      request.headers[key] = value
    end
    allow(access_token).to receive(:find_by_token).with(token).and_return(
      {
        "expires_at" => expires_at,
        "metadata" => {
          "api_key"        => parse_api_key,
          "application_id" => parse_application_id
        }.to_json,
        "tokenable_id"   => tokenable_id,
        "tokenable_type" => tokenable_type,
        "tokenable_uid"  => tokenable_uid
      }
    )
  end
end
