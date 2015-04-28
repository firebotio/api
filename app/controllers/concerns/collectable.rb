module Collectable
  extend ActiveSupport::Concern

  included do
    include Sessionable
  end

  def collection
    @collection ||= ModelCollection.new(
      name: collection_name, type: params[:type]
    )
  end

  def collection_name
    "#{access_token.tokenable_type}-#{access_token.tokenable_id}"
  end

  def collection_with_type
    collection.with_type
  end
end
