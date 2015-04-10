class ModelSerializer < ActiveModel::Serializer
  mattr_accessor :schema

  def attributes
    self.schema.keys.each_with_object({}) do |key, hash|
      value = nil
      if respond_to? key
        value = send key
      elsif object.respond_to? key
        value = object.send key
      end
      hash[key] = value
    end
  end

  def id
    object.id.to_s
  end
end
