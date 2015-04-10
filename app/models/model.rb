class Model
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :object_type, type: String

  def with_collection(name)
    with collection: name
  end
end
