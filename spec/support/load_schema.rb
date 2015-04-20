shared_context :load_schema do
  let(:schema) { Schema.new }

  before do
    allow(controller).to receive(:schema).and_return(schema)
    allow(schema).to receive(:model).and_return(
      {
        "schema" => {
          first_name: {
            type: "string"
          },
          id: {
            type: "string"
          }
        }.to_json
      }
    )
  end
end
