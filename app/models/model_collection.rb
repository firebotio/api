class ModelCollection < Collection
  def initialize(options = {})
    super options.merge({ model: Model })
  end
end
