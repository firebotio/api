class ParseObjectSerializer < ActiveModel::Serializer
  mattr_accessor :schema

  def attributes
    self.schema.keys.each_with_object(default_hash) do |key, hash|
      value = nil
      if respond_to? key
        value = send key
      elsif object[key.to_s]
        value = object[key.to_s]
      end
      hash[key] = value
    end
  end

  def created_at
    object["createdAt"]
  end

  def default_hash
    {
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def id
    object.id.to_s
  end

  def updated_at
    object["updatedAt"]
  end
end
