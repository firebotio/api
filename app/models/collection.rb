class Collection
  def initialize(options = {})
    @model = options[:model]
    @name  = options[:name]
    @type  = options[:type]
  end

  delegate :create, to: :resource

  def with_type
    resource.where object_type: @type
  end

  private

  def resource
    @model.with collection: @name
  end
end
