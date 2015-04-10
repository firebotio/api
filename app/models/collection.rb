class Collection
  def initialize(options = {})
    @model = options[:model]
    @name  = options[:name]
    @type  = options[:type]
  end

  delegate :create, to: :query

  def with_type
    query.where object_type: @type
  end

  private

  def query
    @model.with collection: @name
  end
end
