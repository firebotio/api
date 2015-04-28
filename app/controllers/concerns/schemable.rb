module Schemable
  extend ActiveSupport::Concern

  included do
    include Sessionable
  end

  def load_schema
    unless schema.exists?
      render json: { errors: { schema: "invalid for #{object_type} model" } }
    end
  end

  def object_type
    params[:type]
  end

  def permitted
    schema.permitted_params params
  end

  def schema
    @schema ||= Schema.new(
      backend_app_id: access_token.tokenable_id,
      name:           object_type
    )
  end

  def validate_model
    unless validator.valid?
      render json: { errors: validator.errors }
    end
  end

  def validator
    @validator ||= Validator.new(params: permitted, schema: schema)
  end
end
