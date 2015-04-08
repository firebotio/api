class ModelSerializer < ActiveModel::Serializer
  mattr_accessor :schema

  def attributes
    self.schema.each_with_object({}) do |key, hash|
      if respond_to?(key) || object.respond_to?(key)
        hash[key] = respond_to?(key) ? send(key) : object.send(key)
      end
    end
  end

  def id
    object.id.to_s
  end
end
